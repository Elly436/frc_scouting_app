import json
from openpyxl import load_workbook
from openpyxl.chart import LineChart, Reference
import numpy as np
import math

file_name = "qualifications"

categories = ["personal_score", "total_score", "pick up", "auto note 1", "auto note 2", "leave",
              "auto amp", "auto speaker", "teleop amp", "speaker no boost", "speaker boosted",
              "end position", "harmony", "trap"]
#categories = ["personal_score", "total_score", "fadjj"]

workbook = load_workbook(filename=file_name + ".xlsx")
#sheet = workbook["6364"]

# for category in categories:
#     if not category + " ranking" in workbook.sheetnames:
#         workbook.create_sheet(category + " ranking")

def getLetter(number):
    charstr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    chars = list(charstr)
    output = chars[number]
    return output

def splitString(toSplit, splitter):
    returnList = [""]
    for i in range(len(toSplit)):
        if toSplit[i] == splitter and not returnList[len(returnList)-1] == "":
            returnList.append("")
        else:
            returnList[len(returnList) - 1] += toSplit[i]
    # for i in range(len(returnList)):
    #     returnList[i] = int(returnList[i])
    return returnList

def writeRow(rowNumber, list, team):
    activeSheet = workbook[team]
    for i in range(len(list)):
        activeSheet[getLetter(i) + str(rowNumber)] = list[i]


def addMatch(string_data):
    data = splitString(string_data, "*")
    data_dict = {}
    for thing in data:
        split_thing = splitString(thing, ":")
        category = split_thing[0]
        value = split_thing[1]
        if category == "speaker boost":
            data_dict["speaker boosted"] = value
        else:
            data_dict[category] = value
    team = str(data_dict.pop("team"))

    if not team in workbook.sheetnames:
        workbook.create_sheet(team)
        headers = categories
        headers.append("comment")
        headers.append("outlier")
        headers.insert(0, "match")
        writeRow(1, headers, team)
        workbook[team].freeze_panes = "A2"
        categories.remove("comment")
        categories.remove("outlier")
        categories.remove("match")
    activeSheet = workbook[team]
    matchExists = False
    i = 2
    for row in activeSheet.iter_rows(min_row=2, values_only=True):
        if row[0] is None:
            print("adding match")
            activeSheet.insert_rows(idx=i)
            row_data = []
            for category in categories:
                cell = data_dict[category]
                if cell.isnumeric():
                    cell = int(cell)
                row_data.append(cell)
            row_data.append(data_dict["comment"])
            row_data.append(data_dict["outlier"])
            row_data.insert(0, int(data_dict["match"]))
            writeRow(i, row_data, team)
            matchExists = True
            break
        elif row[0] == int(data_dict["match"]):
            print("override")
            row_data = []
            for category in categories:
                cell = data_dict[category]
                if cell.isnumeric():
                    cell = int(cell)
                row_data.append(cell)
            row_data.append(data_dict["comment"])
            row_data.append(data_dict["outlier"])
            row_data.insert(0, int(data_dict["match"]))
            writeRow(i, row_data, team)
            matchExists = True
            break
        elif row[0] > int(data_dict["match"]):
            print("placing match")
            activeSheet.insert_rows(idx=i)
            row_data = []
            for category in categories:
                cell = data_dict[category]
                if cell.isnumeric():
                    cell = int(cell)
                row_data.append(cell)
            row_data.append(data_dict["comment"])
            row_data.append(data_dict["outlier"])
            row_data.insert(0, int(data_dict["match"]))
            writeRow(i, row_data, team)
            matchExists = True
            break

        i += 1
    if not matchExists:
        print("adding data")
        row_data = []
        for category in categories:
            cell = data_dict[category]
            if cell.isnumeric():
                cell = int(cell)
            row_data.append(cell)
        row_data.append(data_dict["comment"])
        row_data.append(data_dict["outlier"])
        row_data.insert(0, int(data_dict["match"]))
        #print(row_data)
        activeSheet.append(row_data)
    # chart = LineChart()
    # points = Reference(worksheet=activeSheet,
    #                  min_row=1,
    #                  min_col=2,
    #                  max_col=3)
    # chart.add_data(points, from_rows=False, titles_from_data=True)
    # activeSheet.add_chart(chart, getLetter(len(data) + 4)+"2")
    # workbook.save(filename="testMatches.xlsx")
    #getAverages(activeSheet)
    workbook.save(filename=file_name + ".xlsx")

def getAverages(activeSheet):
    logs = []
    withOutliers = []
    withoutOutliers = []
    i = 2
    for row in activeSheet.iter_rows(min_row=2):
        logs.append(int(math.log(i, 4)*100))
        i += 1

    c = 1
    for column in activeSheet.iter_cols(min_row=2, min_col=2, max_col=len(categories), values_only=True):
        withOutliers.append(sum(list(np.multiply(list(column), logs)))/sum(logs))
        withoutOutliers.append(sum(list(np.multiply(list(column), logs))) / sum(logs))

        c += 1

    placeInRanking(activeSheet.title, withOutliers, withoutOutliers)
    # for row in activeSheet.iter_rows(min_row=2, values_only=True):
    #     if row[0] > data[0]:
    #         activeSheet.insert_rows(idx=i)
    #         writeRow(i, data, team
    #         break
    #     i += 1

def placeInRanking(team, withOutliers, withoutOutliers):
    done = False
    i = 0
    for category in categories:
        current_sheet = workbook[category + "ranking"]
        r = 2
        for row in current_sheet.iter_rows(min_row=2, min_col=0, max_col=3, values_only=True):
            if row[0] == team:
                writeRow(r, [team, withOutliers, withoutOutliers], category + "ranking")
            r += 1
        r = 2
        for row in current_sheet.iter_rows(min_row=2, min_col=0, max_col=3, values_only=True):
            if row[1] > withOutliers[i]:
                current_sheet.insert_rows(idx=r)
                writeRow(r, [team, withOutliers, withoutOutliers], category + "ranking")
                done = True
            r += 1
        if not done:
            current_sheet.append([team, withOutliers, withoutOutliers])



# Using the values_only because you want to return the cells' values
def printRows():
    for row in workbook["6364"].iter_rows(values_only=True):
        print(row[0])


#writeRow(1, ["personal score", "total score", "objects scored"], "score ranking")
#sheet.freeze_panels = "A2"
#printRows()
# Save the spreadsheet
workbook.save(filename=file_name + ".xlsx")

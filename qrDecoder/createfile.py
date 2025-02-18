from openpyxl import Workbook

rankingCategories = ["personal score", "dcsnl", "dskd + hullo"]
file_name = "test_2"

workbook = Workbook()
for category in rankingCategories:
    workbook.create_sheet(category + " ranking")
    workbook[category + " ranking"].append(["team", "average", "last 5 matches average"])
    workbook["personal score ranking"].freeze_panes = "A2"
workbook.remove(workbook["Sheet"])



workbook.save(filename= file_name + ".xlsx")
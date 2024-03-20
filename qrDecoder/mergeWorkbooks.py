from openpyxl import load_workbook
import spreadsheetCom as ssc

original_name = "idahotest"
merge_name = "idahotest2"

workbook_original = load_workbook(filename=original_name + ".xlsx")
workbook_merge = load_workbook(filename=merge_name + ".xlsx")

sheets_to_ignore = ["personal score ranking", "amp score ranking", "speaker score ranking"]

for sheet in workbook_merge.sheetnames:
    if sheet != sheets_to_ignore:
        merge_sheet = workbook_merge[sheet]
        if not sheet in workbook_original.sheetnames:
            ssc.createTeamSheet(sheet)
        current_sheet = workbook_original[sheet]

        done = False
        i = 2
        for merge_row in merge_sheet.iter_rows(min_row=2, values_only=True):
            for row in current_sheet.iter_rows(min_row=2, values_only=True):
                if row[0] is None:
                    print("adding")
                    current_sheet.insert_rows(idx=i)
                    ssc.writeRow(i, merge_row, sheet)
                    done = True
                    break

                elif row[0] == merge_row[0]:
                    print("duplicate match for the same team?")
                    done = True
                    break

                elif row[0] > merge_row[0]:
                    print("adding but other")
                    current_sheet.insert_rows(idx=i)
                    ssc.writeRow(i, merge_row, sheet)
                    done = True
                    break

                i += 1

            if not done:
                print(i)
                print("adding but other other")
                current_sheet.insert_rows(idx=i)
                ssc.writeRow(i, merge_row, sheet)
                    
    print("done " + sheet)
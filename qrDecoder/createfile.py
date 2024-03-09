from openpyxl import Workbook

workbook = Workbook()
workbook.create_sheet("6364")
workbook.remove(workbook["Sheet"])

workbook.save(filename="qualifications.xlsx")
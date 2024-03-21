from openpyxl import Workbook

workbook = Workbook()
workbook.create_sheet("personal score ranking")
workbook.create_sheet("amp ranking")
workbook.create_sheet("speaker ranking")
workbook["personal score ranking"].append(["team", "score"])
workbook["personal score ranking"].freeze_panes = "A2"
workbook["amp ranking"].append(["team", "score"])
workbook["amp ranking"].freeze_panes = "A2"
workbook["speaker ranking"].append(["team", "score"])
workbook["speaker ranking"].freeze_panes = "A2"
workbook.remove(workbook["Sheet"])

workbook.save(filename="idaho.xlsx")
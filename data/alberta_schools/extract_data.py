import openpyxl
import csv
import json
import os

DATA_DIR = '/Users/administrator/Git/audioproctor/data/alberta_schools'

def enrolment_band(total):
    if total is None:
        return 'unknown'
    if total < 500:
        return 'small'
    elif total < 2000:
        return 'medium'
    elif total < 10000:
        return 'large'
    else:
        return 'metro'

# === EXTRACT AUTHORITIES ===
wb = openpyxl.load_workbook(os.path.join(DATA_DIR, 'authority_enrolment_2024_2025.xlsx'))
ws = wb.active

authorities = []
seen_codes = set()
for row in ws.iter_rows(min_row=2, values_only=True):
    cat, name, code, *grades, total = row
    if not name or str(name).startswith('*'):
        continue
    code = str(code).strip()
    if code in seen_codes:
        continue
    seen_codes.add(code)
    authorities.append({
        'name': str(name).strip(),
        'authority_code': code,
        'category': str(cat).strip() if cat else '',
        'total_enrolment': total if total is not None else 0,
        'enrolment_band': enrolment_band(total),
    })

print(f'Extracted {len(authorities)} authorities')

# Write CSV
with open(os.path.join(DATA_DIR, 'divisions.csv'), 'w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=['name', 'authority_code', 'category', 'total_enrolment', 'enrolment_band'])
    writer.writeheader()
    for a in authorities:
        writer.writerow(a)

# Write JSON
with open(os.path.join(DATA_DIR, 'divisions.json'), 'w') as f:
    json.dump(authorities, f, indent=2)

# === EXTRACT SCHOOLS ===
wb2 = openpyxl.load_workbook(os.path.join(DATA_DIR, 'school_enrolment_2024_2025.xlsx'))
ws2 = wb2.active

schools = []
seen_school_codes = set()
for row in ws2.iter_rows(min_row=2, values_only=True):
    cat, auth_name, auth_code, school_name, school_code, *grades, total = row
    if not school_name or str(school_name).startswith('*'):
        continue
    sc = str(school_code).strip() if school_code else ''
    if sc in seen_school_codes:
        continue
    seen_school_codes.add(sc)
    schools.append({
        'name': str(school_name).strip(),
        'school_code': sc,
        'authority_code': str(auth_code).strip() if auth_code else '',
        'authority_name': str(auth_name).strip() if auth_name else '',
        'category': str(cat).strip() if cat else '',
        'total_enrolment': total if total is not None else 0,
    })

print(f'Extracted {len(schools)} schools')

with open(os.path.join(DATA_DIR, 'schools.csv'), 'w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=['name', 'school_code', 'authority_code', 'authority_name', 'category', 'total_enrolment'])
    writer.writeheader()
    for s in schools:
        writer.writerow(s)

with open(os.path.join(DATA_DIR, 'schools.json'), 'w') as f:
    json.dump(schools, f, indent=2)

# === SUMMARY ===
from collections import Counter
print('\n=== SUMMARY ===')
print(f'Divisions: {len(authorities)}')
print(f'Schools: {len(schools)}')
print()
print('Categories breakdown:')
cats = Counter(a['category'] for a in authorities)
for cat, count in cats.most_common():
    print(f'  {cat}: {count} divisions')

print('\n=== CATHOLIC SEPARATE SCHOOL DIVISIONS ===')
separate = [a for a in authorities if a['category'] == 'Separate']
for s in separate:
    print(f"  {s['name']} | Code: {s['authority_code']} | Enrolment: {s['total_enrolment']} | Band: {s['enrolment_band']}")

print('\n=== SAMPLE DIVISIONS (first 5) ===')
for a in authorities[:5]:
    print(f"  {a['name']} [{a['authority_code']}] - {a['category']} - {a['total_enrolment']} students ({a['enrolment_band']})")

print('\n=== SAMPLE SCHOOLS (first 5) ===')
for s in schools[:5]:
    print(f"  {s['name']} [{s['school_code']}] -> {s['authority_name']} [{s['authority_code']}] ({s['category']})")

import re

with open("papers_analysis_raw.txt", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

papers = content.split("================================================================================")

for p in papers:
    if not p.strip():
        continue
    lines = [l.strip() for l in p.strip().split("\n") if l.strip()]
    file_header = lines[0] if lines else "UNKNOWN"
    print("\n" + "#"*70)
    print(file_header)
    print("#"*70)
    
    # print first 50 lines to see title, abstract, authors
    print("\n[FIRST 40 LINES]")
    for l in lines[1:45]:
        print("  " + l)

import os
import re

with open("papers_analysis_raw.txt", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# Split by file markers
sections = re.split(r"={5,}\s*FILE:\s*([^\n]+)\s*\(Total Pages:\s*(\d+)\)\s*={5,}", text)

with open("papers_breakdown.md", "w", encoding="utf-8") as out:
    out.write("# Detailed Breakdown of Papers in the `papers/` Directory\n\n")
    
    for i in range(1, len(sections), 3):
        filename = sections[i].strip()
        pages = sections[i+1].strip()
        body = sections[i+2]
        
        out.write(f"## Paper: `{filename}` (Total Pages: {pages})\n\n")
        
        # Extract first 3000 chars
        first_part = body[:4000]
        # Clean up some weird spaces
        clean_first = "\n".join([line.strip() for line in first_part.splitlines() if line.strip()])
        out.write("### Introduction / Abstract / Metadata Snippet:\n```text\n")
        out.write(clean_first[:2500])
        out.write("\n```\n\n")
        
        # Search for sections like Conclusion, Results, Future Work, Discussion
        out.write("### Extracted Key Sections (Discussion / Conclusion / Results):\n")
        
        # Look for conclusion
        concl_match = re.search(r"(conclusion|concluding remarks|summary|future work)(.*?)(references|\Z)", body, re.IGNORECASE | re.DOTALL)
        if concl_match:
            concl_text = concl_match.group(2)[:3000]
            clean_concl = "\n".join([line.strip() for line in concl_text.splitlines() if line.strip()])
            out.write("#### Conclusion / Summary:\n```text\n")
            out.write(clean_concl)
            out.write("\n```\n\n")
        else:
            out.write("*(Conclusion header not directly matched by regex - extracting last 2000 chars)*\n```text\n")
            last_part = body[-2000:]
            clean_last = "\n".join([line.strip() for line in last_part.splitlines() if line.strip()])
            out.write(clean_last)
            out.write("\n```\n\n")

print("Generated papers_breakdown.md successfully.")

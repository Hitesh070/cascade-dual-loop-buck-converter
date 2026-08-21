import re

with open("papers_analysis_raw.txt", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

sections = re.split(r"={5,}\s*FILE:\s*([^\n]+)\s*\(Total Pages:\s*(\d+)\)\s*={5,}", text)

with open("papers_deep_analysis.md", "w", encoding="utf-8") as out:
    for i in range(1, len(sections), 3):
        filename = sections[i].strip()
        pages = sections[i+1].strip()
        body = sections[i+2]
        
        out.write(f"\n==================================================\n")
        out.write(f"ANALYSIS OF: {filename} ({pages} pages)\n")
        out.write(f"==================================================\n")
        
        # Search for limitations, future, hardware, control loop, experimental keywords
        keywords = ["limit", "disadvantage", "future", "hardware", "experiment", "transient", "stability", "saturation", "current limit", "discrete", "microcontroller", "digital"]
        
        out.write("\n--- KEY PARAGRAPHS MENTIONING LIMITATIONS / FUTURE WORK / HARDWARE ---\n")
        paras = body.split("\n\n")
        for p in paras:
            p_lower = p.lower()
            if any(k in p_lower for k in ["future work", "further investigation", "further validation", "limitation", "drawback", "non-linear effect", "saturation", "anti-windup", "switch over", "cc/cv", "boundary"]):
                if len(p.strip()) > 100:
                    out.write("\n> " + "\n> ".join(p.strip().splitlines()[:10]) + "\n")

print("Deep analysis extracted.")

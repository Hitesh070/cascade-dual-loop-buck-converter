import os
from pypdf import PdfReader

papers_dir = os.path.join(os.path.dirname(__file__), "papers")
files = [f for f in os.listdir(papers_dir) if f.endswith(".pdf")]

output_file = os.path.join(os.path.dirname(__file__), "papers_analysis_raw.txt")

with open(output_file, "w", encoding="utf-8") as out:
    for f in files:
        filepath = os.path.join(papers_dir, f)
        reader = PdfReader(filepath)
        num_pages = len(reader.pages)
        out.write(f"\n{'='*80}\nFILE: {f} (Total Pages: {num_pages})\n{'='*80}\n")
        
        full_text = []
        for idx, page in enumerate(reader.pages):
            text = page.extract_text() or ""
            out.write(f"\n--- PAGE {idx+1} ---\n")
            out.write(text)
            out.write("\n")

print(f"Extraction complete. Output written to {output_file}")

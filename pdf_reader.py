import fitz  # PyMuPDF

async def extract_rfq_data(file):
    with fitz.open(stream=await file.read(), filetype="pdf") as pdf:
        text = ""
        for page in pdf:
            text += page.get_text("text")
    return text[:2000]

import fitz  # PyMuPDF
import os
from dotenv import load_dotenv
from openai import OpenAI

# -----------------------------------
# Load environment and initialize client
# -----------------------------------
load_dotenv()
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


# -----------------------------------
# PDF Text Extraction
# -----------------------------------
def extract_text_from_pdf(pdf_path: str) -> str:
    """
    Extracts text from a given PDF file using PyMuPDF (fitz).
    Returns the text content as a single string.
    """
    text = ""
    with fitz.open(pdf_path) as doc:
        for page in doc:
            text += page.get_text("text")
    return text.strip()


# -----------------------------------
# AI Supplier Matching
# -----------------------------------
def ai_match_suppliers(rfq_text: str, suppliers_data: list):
    """
    Uses AI to match supplier products to an uploaded RFQ (Request for Quotation).
    Compares extracted text against known supplier data and ranks matches.
    """
    if not suppliers_data:
        return {
            "error": "No supplier data found. Please run /scrape_suppliers first."
        }

    # Create supplier catalog text
    catalog = "\n".join(
        f"{s['supplier']} ({s['region']}): {s.get('name','N/A')} – {s.get('price','N/A')}"
        for s in suppliers_data[:100]
    )

    try:
        # Compose the AI prompt
        messages = [
            {
                "role": "system",
                "content": (
                    "You are Atlas AI, an intelligent procurement assistant. "
                    "Given a supplier catalog and an RFQ document, identify the most relevant suppliers, "
                    "compare product matches, pricing if available, and highlight the top recommendations. "
                    "Respond in JSON with 'matches' (list) and 'summary' (string)."
                ),
            },
            {
                "role": "user",
                "content": (
                    f"Supplier catalog:\n{catalog}\n\n"
                    f"RFQ text:\n{rfq_text[:3000]}\n\n"
                    "Return only a JSON object with two keys: 'matches' (a ranked list of suppliers) and 'summary' (plain English explanation)."
                ),
            },
        ]

        # Call OpenAI API
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=messages,
            max_tokens=600,
            response_format={"type": "json_object"},
        )

        result = response.choices[0].message.content
        return result

    except Exception as e:
        return {"error": f"AI matching failed: {e}"}
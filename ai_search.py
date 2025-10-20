from openai import OpenAI
import os

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def ai_search_suppliers(query):
    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "You are Atlas AI, a procurement assistant."},
                {"role": "user", "content": f"Find suppliers for: {query}. Return JSON with matches and summary."}
            ],
            response_format={"type": "json_object"},
            max_tokens=300
        )
        return response.choices[0].message.content
    except Exception as e:
        return {"error": str(e)}

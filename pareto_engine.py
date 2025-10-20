def compare_suppliers(data, rule="80-20"):
    if not data:
        return {"error": "No data provided"}

    ratio = 0.8 if rule == "80-20" else 0.9
    split = int(len(data) * ratio)
    cheap = data[:split]
    premium = data[split:]
    return {"cheap_suppliers": cheap, "premium_suppliers": premium}

from fastapi import FastAPI, WebSocket
from fastapi.middleware.cors import CORSMiddleware
from scraper import scrape_suppliers

app = FastAPI(title="Torque Empire Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=['http://localhost:5173', 'http://127.0.0.1:5173'],
    allow_methods=['*'],
    allow_headers=['*'],
)

@app.websocket('/ws/suppliers')
async def ws_suppliers(websocket: WebSocket):
    await websocket.accept()
    try:
        async def send_message(msg: str):
            await websocket.send_text(msg)

        # Call the scraper and stream results back
        await scrape_suppliers(send_message)
        await websocket.send_text("✅ Scraping complete")

    except Exception as e:
        await websocket.send_text(f'❌ Error: {str(e)}')

    finally:
        await websocket.close()
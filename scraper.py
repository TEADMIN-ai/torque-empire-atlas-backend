import asyncio

async def scrape_suppliers(callback):
    for i in range(1, 6):
        await asyncio.sleep(1)
        await callback(f'🔍 Found supplier {i}')
    await callback('✅ All suppliers scraped.')

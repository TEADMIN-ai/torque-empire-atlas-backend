import React, { useState } from "react";

export default function Dashboard() {
  const [summary, setSummary] = useState("Ready.");
  const [file, setFile] = useState(null);

  const handleFileChange = (e) => {
    setFile(e.target.files[0]);
  };

  const handleUpload = async () => {
    if (!file) return setSummary("⚠️ Please select a file first.");
    const formData = new FormData();
    formData.append("file", file);

    try {
      const res = await fetch("http://127.0.0.1:8000/upload_rfq", {
        method: "POST",
        body: formData,
      });
      const data = await res.json();
      setSummary(JSON.stringify(data, null, 2));
    } catch (err) {
      setSummary("❌ Upload failed: " + err.message);
    }
  };

  const handleScrape = async () => {
    try {
      const res = await fetch("http://127.0.0.1:8000/scrape_suppliers");
      const data = await res.json();
      setSummary(JSON.stringify(data, null, 2));
    } catch (err) {
      setSummary("❌ Scrape failed: " + err.message);
    }
  };

  const handleLiveScrape = () => {
    const socket = new WebSocket("ws://127.0.0.1:8000/ws/suppliers");
    setSummary("🔄 Connecting to supplier stream...");

    socket.onmessage = (event) => {
      setSummary((prev) => prev + "\n" + event.data);
    };

    socket.onopen = () => setSummary("✅ Connected — scraping started...");
    socket.onerror = () => setSummary("❌ Connection error");
    socket.onclose = () => setSummary((prev) => prev + "\n🚪 Connection closed.");
  };

  return (
    <div className="min-h-screen bg-gray-900 text-white p-8">
      <h1 className="text-3xl font-bold text-blue-400 mb-6">Torque Empire Atlas Dashboard</h1>

      {/* Upload Section */}
      <div className="mb-6 bg-gray-800 p-6 rounded-2xl shadow-lg">
        <h2 className="text-xl font-semibold mb-4 text-gray-200">Upload RFQ</h2>
        <div className="flex items-center gap-4">
          <label
            htmlFor="rfq-upload"
            className="cursor-pointer bg-blue-600 hover:bg-blue-500 px-4 py-2 rounded font-semibold transition"
          >
            Choose File
          </label>
          <input
            id="rfq-upload"
            name="rfq-upload"
            type="file"
            className="hidden"
            onChange={handleFileChange}
          />
          <button
            onClick={handleUpload}
            className="bg-green-600 hover:bg-green-500 px-6 py-2 rounded font-semibold transition-all"
          >
            ⬆️ Upload
          </button>
        </div>
        {file && <p className="mt-2 text-sm text-gray-400">{file.name}</p>}
      </div>

      {/* Scraping Buttons */}
      <div className="flex gap-4 mb-6">
        <button
          onClick={handleScrape}
          className="bg-purple-600 hover:bg-purple-500 px-6 py-2 rounded font-semibold transition-all"
        >
          🧩 Scrape Suppliers
        </button>
        <button
          onClick={handleLiveScrape}
          className="bg-yellow-500 hover:bg-yellow-400 px-6 py-2 rounded font-semibold transition-all"
        >
          ⚡ Live Scrape (WebSocket)
        </button>
      </div>

      {/* Summary Output */}
      <div className="bg-gray-800 p-4 rounded-2xl shadow-lg overflow-y-auto max-h-96 whitespace-pre-wrap">
        <h2 className="text-lg font-semibold mb-2 text-blue-300">📜 Summary</h2>
        <pre className="text-sm text-gray-300">{summary}</pre>
      </div>
    </div>
  );
}
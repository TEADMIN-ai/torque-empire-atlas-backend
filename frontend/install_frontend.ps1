Write-Host "🚀 Initializing Torque Empire Atlas Frontend Setup..." -ForegroundColor Cyan

# Step 1: Ensure npm is ready
if (!(Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js and npm are not installed. Please install them first from https://nodejs.org/" -ForegroundColor Red
    exit
}

# Step 2: Install core dependencies
Write-Host "📦 Installing React, Tailwind, Axios & Icons..."
npm install axios lucide-react
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Step 3: Configure Tailwind
@"
/** @type {{import('tailwindcss').Config}} */
export default {
  content: ["./index.html", "./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {
      colors: {
        atlasBlue: "#00C2FF",
        atlasDark: "#0A0F1E",
        atlasGray: "#1C1F2B",
      },
      fontFamily: {
        display: ["Orbitron", "sans-serif"],
        body: ["Inter", "sans-serif"],
      },
    },
  },
  plugins: [],
};
"@ | Out-File -Encoding UTF8 tailwind.config.js

# Step 4: Create src folder if missing
if (!(Test-Path "src")) { New-Item -ItemType Directory "src" | Out-Null }
if (!(Test-Path "src\components")) { New-Item -ItemType Directory "src\components" | Out-Null }

# Step 5: Write App.jsx
@"
import React, { useState } from "react";
import axios from "axios";
import { CloudUpload, Search } from "lucide-react";
import SupplierResults from "./components/SupplierResults";

const App = () => {
  const [file, setFile] = useState(null);
  const [status, setStatus] = useState("Awaiting RFQ upload...");
  const [results, setResults] = useState([]);

  const handleFileChange = (e) => setFile(e.target.files[0]);

  const handleUpload = async () => {
    if (!file) return alert("Please upload a PDF RFQ first.");

    const formData = new FormData();
    formData.append("file", file);
    setStatus("Processing RFQ...");

    try {
      await axios.post("http://127.0.0.1:8000/read_pdf", formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });
      setStatus("Searching suppliers...");
      const compareRes = await axios.get("http://127.0.0.1:8000/compare_suppliers");
      setResults(compareRes.data.top_suppliers || []);
      setStatus("✅ RFQ processed successfully!");
    } catch (err) {
      console.error(err);
      setStatus("❌ Failed to process RFQ.");
      alert("Failed to process RFQ — check backend.");
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-atlasDark via-black to-atlasGray flex flex-col items-center py-10 px-6">
      <h1 className="text-5xl font-display text-atlasBlue mb-3 tracking-wide">
        Torque Empire Atlas Dashboard
      </h1>
      <p className="text-gray-400 mb-10">{status}</p>

      <div className="bg-atlasGray p-8 rounded-2xl shadow-lg w-full max-w-xl flex flex-col items-center">
        <label
          htmlFor="fileUpload"
          className="flex flex-col items-center justify-center w-full border-2 border-dashed border-atlasBlue/40 rounded-xl p-10 hover:border-atlasBlue/80 cursor-pointer transition-all"
        >
          <CloudUpload className="text-atlasBlue w-10 h-10 mb-3" />
          <span className="text-sm text-gray-400">
            Drag & drop your RFQ PDF or click to upload
          </span>
          <input
            id="fileUpload"
            type="file"
            accept="application/pdf"
            onChange={handleFileChange}
            className="hidden"
          />
        </label>

        <button
          onClick={handleUpload}
          className="mt-6 flex items-center bg-atlasBlue hover:bg-blue-400 text-black px-6 py-2 rounded-xl font-semibold shadow-lg"
        >
          <Search className="mr-2 w-4 h-4" />
          Process RFQ
        </button>
      </div>

      <SupplierResults results={results} />
    </div>
  );
};

export default App;
"@ | Out-File -Encoding UTF8 src\App.jsx

# Step 6: Write SupplierResults.jsx
@"
import React from "react";

const SupplierResults = ({ results }) => {
  if (!results || results.length === 0)
    return <p className='mt-10 text-gray-400'>No supplier results yet.</p>;

  let parsedResults;
  try {
    parsedResults = JSON.parse(results);
  } catch {
    parsedResults = results;
  }

  return (
    <div className='mt-10 w-full max-w-4xl grid grid-cols-1 md:grid-cols-2 gap-6'>
      {Object.entries(parsedResults).map(([key, supplier], idx) => (
        <div
          key={idx}
          className='bg-gray-800 p-6 rounded-2xl shadow-lg hover:shadow-blue-500/30 transition-all'
        >
          <h2 className='text-xl font-bold text-blue-400 mb-2'>
            Supplier {idx + 1}
          </h2>
          <p className='text-sm text-gray-300'>{supplier}</p>
        </div>
      ))}
    </div>
  );
};

export default SupplierResults;
"@ | Out-File -Encoding UTF8 src\components\SupplierResults.jsx

# Step 7: Start frontend
Write-Host "✅ Setup complete. Launching frontend server..." -ForegroundColor Green
npm start
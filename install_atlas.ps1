# ╔════════════════════════════════════════════════════╗
# ║ Torque Empire Atlas - One Command Full Deployment  ║
# ╚════════════════════════════════════════════════════╝

Write-Host "⚙️ Initializing Torque Empire Atlas Full Setup..." -ForegroundColor Cyan

# --- Variables ---
$basePath = "$env:USERPROFILE\Desktop\torque-empire-atlas-backend"
$frontendPath = "$env:USERPROFILE\Desktop\frontend"
Set-Location $basePath

# --- Step 1: Python Virtual Environment ---
if (!(Test-Path "venv")) {
    Write-Host "🧱 Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
}
Write-Host "🚀 Activating virtual environment..." -ForegroundColor Green
& .\venv\Scripts\activate

# --- Step 2: Install Python dependencies ---
Write-Host "📦 Installing backend dependencies..." -ForegroundColor Cyan
pip install --upgrade pip
pip install fastapi uvicorn[standard] python-dotenv requests beautifulsoup4 openai geopy

# --- Step 3: Create .env if missing ---
if (!(Test-Path ".env")) {
@"
OPENAI_API_KEY=sk-REPLACE_WITH_YOUR_KEY
EMAIL_USER=procurement@torqueempire.co.za
EMAIL_PASS=YOUR_APP_PASSWORD
EMAIL_CC=ckaraniete.za@gmail.com,mcoetzeete.za@gmail.com,slennetste.za@gmail.com,tvalteinte.za@gmail.com
"@ | Out-File -Encoding UTF8 ".env"
    Write-Host "🪶 .env file created — please update your API key and email settings." -ForegroundColor Yellow
}

# --- Step 4: Create Frontend if not found ---
if (!(Test-Path $frontendPath)) {
    Write-Host "🌐 Creating new React frontend..." -ForegroundColor Cyan
    Set-Location "$env:USERPROFILE\Desktop"
    npx create-react-app frontend
}

# --- Step 5: Install Frontend dependencies ---
Set-Location $frontendPath
Write-Host "📦 Installing frontend dependencies..." -ForegroundColor Cyan
npm install axios react-router-dom tailwindcss framer-motion
npx tailwindcss init -p

# --- Step 6: Inject Frontend Files ---
$srcPath = "$frontendPath\src"
$componentsPath = "$srcPath\components"
if (!(Test-Path $componentsPath)) { New-Item -ItemType Directory -Path $componentsPath | Out-Null }

# --- App.jsx ---
@"
import {{ BrowserRouter as Router, Routes, Route }} from "react-router-dom";
import Dashboard from "./components/Dashboard";
import SupplierResponseForm from "./components/SupplierResponseForm";
import ResultsScreen from "./components/ResultsScreen";

export default function App() {{
  return (
    <Router>
      <Routes>
        <Route path="/" element={{<Dashboard />}} />
        <Route path="/supplier-response" element={{<SupplierResponseForm rfqId="RFQ-2025-001" />}} />
        <Route path="/results" element={{<ResultsScreen />}} />
      </Routes>
    </Router>
  );
}}
"@ | Out-File -Encoding UTF8 "$srcPath\App.jsx"

# --- index.jsx ---
@"
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import "./index.css";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
"@ | Out-File -Encoding UTF8 "$srcPath\index.jsx"

# --- Dashboard.jsx ---
@"
import {{ useNavigate }} from "react-router-dom";
export default function Dashboard() {{
  const navigate = useNavigate();
  return (
    <div className='min-h-screen bg-gray-950 text-white flex flex-col items-center justify-center space-y-6'>
      <h1 className='text-4xl font-bold mb-6 text-yellow-400'>Torque Empire Atlas Dashboard</h1>
      <div className='flex space-x-4'>
        <button onClick={{() => navigate('/supplier-response')}} className='bg-blue-600 hover:bg-blue-500 px-6 py-3 rounded-xl text-lg font-semibold shadow-md'>Submit Supplier Quote</button>
        <button onClick={{() => navigate('/results')}} className='bg-green-600 hover:bg-green-500 px-6 py-3 rounded-xl text-lg font-semibold shadow-md'>View RFQ Results</button>
      </div>
    </div>
  );
}}
"@ | Out-File -Encoding UTF8 "$componentsPath\Dashboard.jsx"

# --- SupplierResponseForm.jsx ---
@"
import {{ useState }} from "react";
import axios from "axios";

export default function SupplierResponseForm({{ rfqId }}) {{
  const [form, setForm] = useState({{ company: '', contact: '', email: '', product: '', quantity: '', price: '', delivery_time: '', notes: '' }});
  const [file, setFile] = useState(null);
  const [status, setStatus] = useState('');

  const handleChange = e => setForm({{ ...form, [e.target.name]: e.target.value }});

  const handleSubmit = async e => {{
    e.preventDefault();
    const data = new FormData();
    Object.entries(form).forEach(([k,v]) => data.append(k,v));
    data.append('rfq_id', rfqId);
    if (file) data.append('file', file);
    try {{
      const res = await axios.post('http://127.0.0.1:8000/supplier_response', data);
      setStatus(res.data.message);
    }} catch (err) {{
      setStatus('Upload failed: ' + err.message);
    }}
  }};

  return (
    <div className='max-w-xl mx-auto p-6 bg-gray-900 rounded-xl shadow-xl text-white'>
      <h2 className='text-xl font-semibold mb-4'>Submit Your Quote</h2>
      <form onSubmit={{handleSubmit}} className='space-y-3'>
        {{["company","contact","email","product","quantity","price","delivery_time"].map(f => (
          <input key={{f}} name={{f}} placeholder={{f.replace("_"," ")}} onChange={{handleChange}} required className='w-full p-2 bg-gray-800 rounded-md'/>
        ))}}
        <textarea name='notes' placeholder='Additional notes...' onChange={{handleChange}} className='w-full p-2 bg-gray-800 rounded-md'/>
        <input type='file' onChange={{e => setFile(e.target.files[0])}} className='w-full p-2 bg-gray-800 rounded-md'/>
        <button type='submit' className='w-full bg-yellow-600 hover:bg-yellow-500 py-2 rounded-md font-semibold'>Submit Quote</button>
      </form>
      {{status && <p className='mt-4 text-green-400'>{{status}}</p>}}
    </div>
  );
}}
"@ | Out-File -Encoding UTF8 "$componentsPath\SupplierResponseForm.jsx"

# --- ResultsScreen.jsx ---
@"
import {{ useEffect, useState }} from "react";
import axios from "axios";

export default function ResultsScreen() {{
  const [results, setResults] = useState([]);
  const [rfqId, setRfqId] = useState('RFQ-2025-001');

  useEffect(() => {{
    axios.get(`http://127.0.0.1:8000/rfq_status/${{rfqId}}`)
      .then(res => setResults(res.data.responses || []))
      .catch(() => setResults([]));
  }}, [rfqId]);

  return (
    <div className='min-h-screen bg-gray-950 text-white p-8'>
      <h2 className='text-3xl font-bold mb-6 text-yellow-400'>RFQ Results</h2>
      <input value={{rfqId}} onChange={{e => setRfqId(e.target.value)}} placeholder='Enter RFQ ID' className='p-2 rounded-md bg-gray-800 text-white mb-4'/>
      {{results.length === 0 ? (
        <p>No results yet.</p>
      ) : (
        <table className='w-full text-left border-collapse'>
          <thead className='bg-gray-800'>
            <tr><th className='p-3'>Supplier</th><th className='p-3'>Product</th><th className='p-3'>Qty</th><th className='p-3'>Price</th><th className='p-3'>Delivery</th><th className='p-3'>Notes</th></tr>
          </thead>
          <tbody>
            {{results.slice(0,2).map((r,i)=>(
              <tr key={{i}} className='border-b border-gray-700 hover:bg-gray-800'>
                <td className='p-3'>{{r.company}}</td>
                <td className='p-3'>{{r.product}}</td>
                <td className='p-3'>{{r.quantity}}</td>
                <td className='p-3 text-yellow-400 font-bold'>R{{r.price}}</td>
                <td className='p-3'>{{r.delivery_time}}</td>
                <td className='p-3'>{{r.notes}}</td>
              </tr>
            ))}}
          </tbody>
        </table>
      )}}
    </div>
  );
}}
"@ | Out-File -Encoding UTF8 "$componentsPath\ResultsScreen.jsx"

# --- Step 7: Start Backend + Frontend ---
Write-Host "🚀 Launching backend..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$basePath'; .\venv\Scripts\activate; uvicorn main:app --reload --port 8000"

Write-Host "💻 Launching frontend..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$frontendPath'; npm start"

Write-Host "✅ Torque Empire Atlas Deployment Complete!" -ForegroundColor Yellow
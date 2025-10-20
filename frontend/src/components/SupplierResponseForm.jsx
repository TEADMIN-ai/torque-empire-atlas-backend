import { useState } from "react";
import axios from "axios";

export default function SupplierResponseForm({ rfqId }) {
  const [form, setForm] = useState({
    company: "", contact: "", email: "", product: "", quantity: "",
    price: "", delivery_time: "", notes: ""
  });
  const [file, setFile] = useState(null);
  const [status, setStatus] = useState("");

  const handleChange = e => setForm({ ...form, [e.target.name]: e.target.value });

  const handleSubmit = async e => {
    e.preventDefault();
    const data = new FormData();
    Object.entries(form).forEach(([k, v]) => data.append(k, v));
    data.append("rfq_id", rfqId);
    if (file) data.append("file", file);

    try {
      const res = await axios.post("http://127.0.0.1:8000/supplier_response", data);
      setStatus(res.data.message);
    } catch (err) {
      setStatus("Upload failed: " + err.message);
    }
  };

  return (
    <div className="max-w-xl mx-auto p-6 bg-gray-900 rounded-xl shadow-xl text-white">
      <h2 className="text-xl font-semibold mb-4">Submit Your Quote</h2>
      <form onSubmit={handleSubmit} className="space-y-3">
        {["company", "contact", "email", "product", "quantity", "price", "delivery_time"].map(f => (
          <input key={f} name={f} placeholder={f.replace("_", " ")} onChange={handleChange}
            required className="w-full p-2 bg-gray-800 rounded-md" />
        ))}
        <textarea name="notes" placeholder="Additional notes..." onChange={handleChange}
          className="w-full p-2 bg-gray-800 rounded-md" />
        <input type="file" onChange={e => setFile(e.target.files[0])}
          className="w-full p-2 bg-gray-800 rounded-md" />
        <button type="submit" className="w-full bg-yellow-600 hover:bg-yellow-500 py-2 rounded-md font-semibold">
          Submit Quote
        </button>
      </form>
      {status && <p className="mt-4 text-green-400">{status}</p>}
    </div>
  );
}
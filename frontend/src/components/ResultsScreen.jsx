import { useEffect, useState } from "react";
import axios from "axios";

export default function ResultsScreen() {
  const [results, setResults] = useState([]);
  const [rfqId, setRfqId] = useState("RFQ-2025-001");

  useEffect(() => {
    axios.get(`http://127.0.0.1:8000/rfq_status/${rfqId}`)
      .then(res => setResults(res.data.responses || []))
      .catch(() => setResults([]));
  }, [rfqId]);

  return (
    <div className="min-h-screen bg-gray-950 text-white p-8">
      <h2 className="text-3xl font-bold mb-6 text-yellow-400">RFQ Results</h2>
      <div className="mb-4">
        <input value={rfqId} onChange={e => setRfqId(e.target.value)}
          placeholder="Enter RFQ ID" className="p-2 rounded-md bg-gray-800 text-white" />
      </div>

      {results.length === 0 ? (
        <p>No results yet. Please check again after suppliers respond.</p>
      ) : (
        <table className="w-full text-left border-collapse">
          <thead className="bg-gray-800">
            <tr>
              <th className="p-3">Supplier</th>
              <th className="p-3">Product</th>
              <th className="p-3">Quantity</th>
              <th className="p-3">Price</th>
              <th className="p-3">Delivery</th>
              <th className="p-3">Notes</th>
            </tr>
          </thead>
          <tbody>
            {results.slice(0, 2).map((r, i) => (
              <tr key={i} className="border-b border-gray-700 hover:bg-gray-800">
                <td className="p-3">{r.company}</td>
                <td className="p-3">{r.product}</td>
                <td className="p-3">{r.quantity}</td>
                <td className="p-3 text-yellow-400 font-bold">R{r.price}</td>
                <td className="p-3">{r.delivery_time}</td>
                <td className="p-3">{r.notes}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
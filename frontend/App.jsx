import React, { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { CloudArrowUpIcon } from "@heroicons/react/24/solid";

export default function App() {
  const [loading, setLoading] = useState(true);
  const [file, setFile] = useState(null);

  useEffect(() => {
    const timer = setTimeout(() => setLoading(false), 2500);
    return () => clearTimeout(timer);
  }, []);

  const handleFileUpload = (e) => setFile(e.target.files[0]);

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#05070c] to-[#0A0F1E] text-white flex flex-col items-center justify-center font-body p-4">
      <AnimatePresence>
        {loading ? (
          <motion.div
            key="loader"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 1 }}
            className="text-center"
          >
            <motion.div
              className="text-5xl font-display text-atlasBlue mb-3"
              animate={{ rotate: [0, 360] }}
              transition={{ repeat: Infinity, duration: 4, ease: "linear" }}
            >
              ⚙️
            </motion.div>
            <p className="text-lg tracking-widest text-gray-300">
              Atlas System Initializing...
            </p>
          </motion.div>
        ) : (
          <motion.div
            key="main"
            initial={{ opacity: 0, y: 40 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1.2 }}
            className="w-full max-w-2xl text-center bg-[#101828]/80 p-10 rounded-3xl shadow-xl backdrop-blur-md border border-[#1C1F2B]"
          >
            <h1 className="text-3xl font-display text-atlasBlue mb-6 drop-shadow-lg">
              Torque Empire Atlas Dashboard
            </h1>

            <label className="block border-2 border-dashed border-atlasBlue rounded-xl p-8 mb-6 cursor-pointer hover:bg-[#0A0F1E]/40 transition-all">
              <CloudArrowUpIcon className="h-10 w-10 mx-auto text-atlasBlue" />
              <p className="mt-2 text-sm text-gray-400">
                Drag & drop your RFQ PDF or click to upload
              </p>
              <input type="file" className="hidden" onChange={handleFileUpload} />
            </label>

            <button className="bg-atlasBlue hover:bg-atlasGray px-8 py-3 rounded-xl text-white font-display shadow-md transition-all">
              Scrape Suppliers
            </button>

            {file && (
              <motion.div
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                className="mt-4 text-sm text-gray-400"
              >
                Uploaded: {file.name}
              </motion.div>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
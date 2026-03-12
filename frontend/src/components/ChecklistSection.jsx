import React from 'react';
import { motion } from 'framer-motion';
import { Check, X } from 'lucide-react';

const ChecklistSection = ({ items }) => {
    if (!items || items.length === 0) return null;

    return (
        <div className="manuscript-container border-accent/10">
            <h3 className="text-xl font-heading text-parchment mb-6 tracking-tight">Component Scrutiny</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {items.map((item, index) => (
                    <motion.div 
                        key={index}
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: index * 0.1 }}
                        className={`
                            flex items-center justify-between p-4 rounded-xl border backdrop-blur-sm
                            ${item.status 
                                ? 'bg-green-400/5 border-green-400/20 text-green-400/80' 
                                : 'bg-red-400/5 border-red-400/20 text-red-400/80'}
                        `}
                    >
                        <span className="text-sm font-medium tracking-wide">{item.label}</span>
                        {item.status ? (
                            <div className="bg-green-400/20 p-1 rounded-full"><Check size={14} /></div>
                        ) : (
                            <div className="bg-red-400/20 p-1 rounded-full"><X size={14} /></div>
                        )}
                    </motion.div>
                ))}
            </div>
        </div>
    );
};

export default ChecklistSection;

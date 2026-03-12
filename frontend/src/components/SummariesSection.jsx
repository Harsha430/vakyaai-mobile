import React from 'react';
import { motion } from 'framer-motion';
import { Target, Linkedin, Mail, Mic } from 'lucide-react';

const SummariesSection = ({ summaries }) => {
    if (!summaries) return null;

    const sections = [
        { id: 'elevator', label: 'Elevator Pitch', icon: Mic, content: summaries.elevator },
        { id: 'linkedin', label: 'LinkedIn Hook', icon: Linkedin, content: summaries.linkedin },
        { id: 'email', label: 'Formal Outreach', icon: Mail, content: summaries.email }
    ];

    return (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {sections.map((sec, i) => (
                <motion.div 
                    key={sec.id}
                    initial={{ opacity: 0, y: 15 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: i * 0.1 }}
                    className="manuscript-container border-accent/10 flex flex-col h-full"
                >
                    <div className="flex items-center gap-3 mb-6 text-accent/60">
                        <sec.icon size={16} />
                        <span className="text-[10px] font-bold uppercase tracking-widest">{sec.label}</span>
                    </div>
                    <p className="text-sm text-parchment/70 leading-relaxed italic flex-grow">
                        "{sec.content}"
                    </p>
                    <button className="mt-6 text-[9px] font-bold text-accent/40 hover:text-accent uppercase tracking-widest transition-colors w-fit">
                        Copy to Archives
                    </button>
                </motion.div>
            ))}
        </div>
    );
};

export default SummariesSection;

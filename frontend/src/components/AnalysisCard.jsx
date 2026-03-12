import React from 'react';
import { motion } from 'framer-motion';

const AnalysisCard = ({ title, items, icon: Icon, colorClass, delay = 0 }) => {
    if (!items || items.length === 0) return null;

    const colorMap = {
        'green-400': {
            border: 'border-green-400/10',
            bg: 'bg-green-400/10',
            icon: 'text-green-400',
            dot: 'bg-green-400/40',
            dotHover: 'group-hover:bg-green-400'
        },
        'red-400': {
            border: 'border-red-400/10',
            bg: 'bg-red-400/10',
            icon: 'text-red-400',
            dot: 'bg-red-400/40',
            dotHover: 'group-hover:bg-red-400'
        },
        'accent': {
            border: 'border-accent/10',
            bg: 'bg-accent/10',
            icon: 'text-accent',
            dot: 'bg-accent/40',
            dotHover: 'group-hover:bg-accent'
        }
    };

    const colors = colorMap[colorClass] || colorMap['accent'];

    return (
        <motion.div
            initial={{ opacity: 0, x: -15 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay, duration: 0.6 }}
            className="manuscript-container"
        >
            <div className={`flex items-center gap-3 mb-6 pb-4 border-b ${colors.border}`}>
                <div className={`p-2 rounded-lg ${colors.bg} ${colors.icon}`}>
                    {Icon && <Icon size={20} />}
                </div>
                <h3 className="font-heading text-lg tracking-tight">{title}</h3>
            </div>
            <ul className="space-y-4">
                {items.map((item, index) => (
                    <li key={index} className="flex items-start gap-4 group">
                        <span className={`mt-2 w-1.5 h-1.5 rounded-full ${colors.dot} ${colors.dotHover} transition-colors flex-shrink-0`} />
                        <span className="text-parchment/70 text-sm leading-relaxed group-hover:text-parchment transition-colors">{item}</span>
                    </li>
                ))}
            </ul>
        </motion.div>
    );
};

export default AnalysisCard;

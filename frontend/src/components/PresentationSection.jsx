import React from 'react';
import { motion } from 'framer-motion';
import { Presentation } from 'lucide-react';

const PresentationSection = ({ slides }) => {
    if (!slides || slides.length === 0) return null;

    return (
        <div className="space-y-8">
            <div className="flex items-center gap-4 mb-8">
                <div className="p-3 bg-accent/10 rounded-2xl text-accent">
                    <Presentation size={24} />
                </div>
                <div>
                    <h3 className="text-2xl font-heading text-parchment tracking-tight">Presentation Architect</h3>
                    <p className="text-parchment/40 text-xs">AI-generated structural outline for your deck.</p>
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {slides.map((slide, index) => (
                    <motion.div 
                        key={index}
                        initial={{ opacity: 0, scale: 0.95 }}
                        animate={{ opacity: 1, scale: 1 }}
                        transition={{ delay: index * 0.1 }}
                        className="manuscript-container border-accent/20 hover:border-accent/40 transition-colors group h-full"
                    >
                        <div className="text-[10px] font-bold text-accent/40 mb-3 uppercase tracking-widest">
                            Slide {index + 1}
                        </div>
                        <h4 className="text-lg font-heading text-accent mb-4 group-hover:text-parchment transition-colors">
                            {slide.title}
                        </h4>
                        <ul className="space-y-2">
                            {slide.content.map((point, i) => (
                                <li key={i} className="text-xs text-parchment/60 leading-relaxed flex gap-2">
                                    <span className="text-accent/30">•</span>
                                    {point}
                                </li>
                            ))}
                        </ul>
                    </motion.div>
                ))}
            </div>
        </div>
    );
};

export default PresentationSection;

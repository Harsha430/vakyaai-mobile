import React from 'react';
import { motion } from 'framer-motion';
import { Brain, MessageCircle, ExternalLink, Zap, PlayCircle, Book, FileCode, Presentation } from 'lucide-react';
import PracticeMode from './PracticeMode';

const GrowthSection = ({ 
    confidence = 0, 
    fillerWords = [], 
    questions = [], 
    resources = [], 
    roadmap = [] 
}) => {
    // Categorize resources
    const categories = ["YouTube", "Blog", "Documentation", "Pitch Deck"];
    const icons = {
        "YouTube": PlayCircle,
        "Blog": Book,
        "Documentation": FileCode,
        "Pitch Deck": Presentation
    };
    
    const safeResources = Array.isArray(resources) ? resources : [];
    
    const groupedResources = categories.reduce((acc, cat) => {
        acc[cat] = safeResources.filter(r => r.category === cat);
        return acc;
    }, {});

    return (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            {/* Left: Communication & Roadmap */}
            <div className="space-y-8">
                {/* Communication Metrics */}
                <div className="manuscript-container border-accent/20 overflow-hidden relative">
                    <div className="absolute top-0 right-0 p-4 opacity-5">
                         <Brain size={120} />
                    </div>
                    <h3 className="text-xl font-heading text-parchment mb-8 flex items-center gap-3">
                         <Brain className="text-accent" size={20} /> Delivery Intel
                    </h3>
                    
                    <div className="space-y-8">
                        <div className="space-y-3">
                            <div className="flex justify-between items-end">
                                <span className="text-[10px] font-bold uppercase tracking-widest text-parchment/40">Confidence Index</span>
                                <span className="text-2xl font-heading text-accent">{confidence}%</span>
                            </div>
                            <div className="h-2 bg-white/5 rounded-full overflow-hidden border border-white/5">
                                <motion.div 
                                    initial={{ width: 0 }}
                                    animate={{ width: `${confidence}%` }}
                                    className="h-full bg-gradient-to-r from-accent/50 to-accent"
                                />
                            </div>
                        </div>

                        <div className="space-y-4">
                            <span className="text-[10px] font-bold uppercase tracking-widest text-parchment/40">Filler Word Detection</span>
                            <div className="flex flex-wrap gap-3">
                                {fillerWords.length > 0 ? fillerWords.map((item, i) => (
                                    <div key={i} className="px-4 py-2 rounded-xl bg-red-400/5 border border-red-400/10 flex items-center gap-3">
                                        <span className="text-sm italic text-parchment/60">"{item.word}"</span>
                                        <span className="text-xs font-bold text-red-400/80 bg-red-400/20 px-1.5 rounded-md">{item.count}</span>
                                    </div>
                                )) : (
                                    <p className="text-xs text-parchment/20 italic">No significant filler words detected.</p>
                                )}
                            </div>
                        </div>
                    </div>
                </div>

                {/* Skill Roadmap (Agentic Learning) */}
                <div className="manuscript-container border-accent/10 relative">
                    <h3 className="text-xl font-heading text-parchment mb-8 flex items-center gap-3">
                         <Zap className="text-accent" size={20} /> Personalized Skill Roadmap
                    </h3>
                    <div className="relative pl-8 space-y-10 border-l border-accent/10 ml-2">
                        {roadmap && roadmap.length > 0 ? roadmap.map((step, i) => (
                            <motion.div 
                                key={i}
                                initial={{ opacity: 0, x: -10 }}
                                animate={{ opacity: 1, x: 0 }}
                                transition={{ delay: i * 0.2 }}
                                className="relative"
                            >
                                <div className="absolute -left-[41px] top-1 p-1 bg-primary border border-accent/40 rounded-full shadow-[0_0_10px_rgba(245,158,11,0.2)]">
                                    <div className="w-2 h-2 bg-accent rounded-full animate-pulse" />
                                </div>
                                <h4 className="text-sm font-bold text-accent uppercase tracking-widest mb-2">{step.title}</h4>
                                <p className="text-xs text-parchment/50 leading-relaxed italic">"{step.description}"</p>
                            </motion.div>
                        )) : (
                            <p className="text-xs text-parchment/20 italic">Achieve professional status to unlock the roadmap.</p>
                        )}
                    </div>
                </div>

                {/* Practice Questions */}
                <div className="space-y-6">
                    <h3 className="text-xl font-heading text-parchment flex items-center gap-3">
                         <MessageCircle className="text-accent" size={20} /> Practice Mode: Reface the Judges
                    </h3>
                    <PracticeMode questions={questions} />
                </div>
            </div>

            {/* Right: Categorized Resources */}
            <div className="manuscript-container border-accent/20 bg-accent/5 backdrop-blur-sm">
                <h3 className="text-xl font-heading text-parchment mb-8 flex items-center gap-3">
                     <Zap className="text-accent" size={20} /> Enlightened Resources
                </h3>
                
                <div className="space-y-10">
                    {categories.map((cat) => {
                        const items = groupedResources[cat];
                        if (items.length === 0) return null;
                        
                        const Icon = icons[cat] || ExternalLink;
                        
                        return (
                            <div key={cat} className="space-y-5">
                                <div className="flex items-center gap-3">
                                    <Icon className="text-accent/40" size={16} />
                                    <span className="text-[10px] font-bold uppercase tracking-[0.2em] text-accent/60">
                                        {cat}
                                    </span>
                                </div>
                                <div className="grid grid-cols-1 gap-4">
                                    {items.map((res, i) => (
                                        <motion.a 
                                            whileHover={{ x: 5 }}
                                            key={i}
                                            href={res.url}
                                            target="_blank"
                                            rel="noopener noreferrer"
                                            className="flex items-center justify-between p-5 rounded-2xl bg-white/5 border border-white/10 hover:border-accent/40 group transition-all shadow-sm hover:shadow-accent/5"
                                        >
                                            <div className="flex flex-col gap-1">
                                                <span className="text-sm font-bold text-parchment/90 group-hover:text-accent transition-colors">
                                                    {res.title}
                                                </span>
                                                <span className="text-[10px] text-parchment/20 uppercase tracking-widest font-mono">
                                                    {cat === 'YouTube' ? 'Watch Tutorial' : 'Read Publication'}
                                                </span>
                                            </div>
                                            <div className="p-2 rounded-full bg-accent/5 text-accent opacity-40 group-hover:opacity-100 group-hover:bg-accent/10 transition-all">
                                                <ExternalLink size={16} />
                                            </div>
                                        </motion.a>
                                    ))}
                                </div>
                            </div>
                        );
                    })}
                </div>

                <div className="pt-8 border-t border-accent/10 mt-12">
                    <p className="text-[10px] text-parchment/20 leading-relaxed italic text-center uppercase tracking-widest">
                        "The archive provides the path; the initiative must be yours."
                    </p>
                </div>
            </div>
        </div>
    );
};

export default GrowthSection;

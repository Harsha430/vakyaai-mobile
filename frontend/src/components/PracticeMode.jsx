import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { MessageSquare, Send, Trophy, RefreshCcw } from 'lucide-react';

const PracticeMode = ({ questions }) => {
    const [currentIdx, setCurrentIdx] = useState(0);
    const [answers, setAnswers] = useState({});
    const [isFinished, setIsFinished] = useState(false);
    const [input, setInput] = useState("");

    const handleNext = () => {
        setAnswers({ ...answers, [currentIdx]: input });
        setInput("");
        if (currentIdx < questions.length - 1) {
            setCurrentIdx(currentIdx + 1);
        } else {
            setIsFinished(true);
        }
    };

    if (!questions || questions.length === 0) return null;

    return (
        <div className="manuscript-container border-accent/20 bg-accent/5 max-w-3xl mx-auto">
            <AnimatePresence mode="wait">
                {!isFinished ? (
                    <motion.div 
                        key={currentIdx}
                        initial={{ opacity: 0, x: 20 }}
                        animate={{ opacity: 1, x: 0 }}
                        exit={{ opacity: 0, x: -20 }}
                        className="space-y-8"
                    >
                        <div className="flex items-center justify-between">
                            <span className="text-[10px] font-bold text-accent uppercase tracking-widest">Question {currentIdx + 1} of {questions.length}</span>
                            <div className="flex gap-1">
                                {questions.map((_, i) => (
                                    <div key={i} className={`h-1 w-4 rounded-full transition-colors ${i <= currentIdx ? 'bg-accent' : 'bg-accent/10'}`} />
                                ))}
                            </div>
                        </div>

                        <h3 className="text-2xl font-heading text-parchment leading-tight italic">
                            "{questions[currentIdx]}"
                        </h3>

                        <div className="relative">
                            <textarea 
                                value={input}
                                onChange={(e) => setInput(e.target.value)}
                                placeholder="State your defense..."
                                className="w-full h-40 bg-white/5 border border-white/10 rounded-2xl p-6 text-parchment outline-none focus:border-accent/40 transition-all resize-none font-body"
                            />
                            <button 
                                onClick={handleNext}
                                disabled={!input.trim()}
                                className="absolute bottom-4 right-4 p-3 bg-accent rounded-xl text-primary disabled:opacity-50 disabled:cursor-not-allowed shadow-lg"
                            >
                                <Send size={20} />
                            </button>
                        </div>
                    </motion.div>
                ) : (
                    <motion.div 
                        initial={{ opacity: 0, scale: 0.9 }}
                        animate={{ opacity: 1, scale: 1 }}
                        className="text-center py-12 space-y-6"
                    >
                        <div className="inline-block p-4 bg-accent/20 rounded-full text-accent mb-4">
                            <Trophy size={48} />
                        </div>
                        <h3 className="text-3xl font-heading text-parchment">Practice Complete</h3>
                        <p className="text-parchment/40 text-sm max-w-sm mx-auto">
                            You have faced the judges. Your responses are recorded in the archives for your own reflection.
                        </p>
                        <button 
                            onClick={() => { setIsFinished(false); setCurrentIdx(0); setAnswers({}); }}
                            className="flex items-center gap-2 mx-auto px-6 py-2 border border-accent/20 rounded-full text-accent hover:bg-accent/10 transition-all text-xs font-bold uppercase tracking-widest"
                        >
                            <RefreshCcw size={14} /> Reface the Judges
                        </button>
                    </motion.div>
                )}
            </AnimatePresence>
        </div>
    );
};

export default PracticeMode;

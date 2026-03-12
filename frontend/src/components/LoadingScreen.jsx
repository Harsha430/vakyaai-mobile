import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Sparkles, Brain, Lock, Gavel } from 'lucide-react';

const steps = [
    { text: "Initializing VākyaAI Engine...", icon: Sparkles },
    { text: "Analyzing Pitch Clarity...", icon: Brain },
    { text: "Evaluating Impact & Reach...", icon: Gavel },
    { text: "Checking Logical Structure...", icon: Lock },
    { text: "Optimizing Persuasion Metrics...", icon: Sparkles },
    { text: "Finalizing Report...", icon: Brain }
];

const LoadingScreen = () => {
    const [currentStep, setCurrentStep] = useState(0);

    useEffect(() => {
        if (currentStep < steps.length - 1) {
            const timeout = setTimeout(() => {
                setCurrentStep(prev => prev + 1);
            }, 1500); // 1.5s per step
            return () => clearTimeout(timeout);
        }
    }, [currentStep]);

    const CurrentIcon = steps[currentStep].icon;

    return (
        <div className="flex flex-col items-center justify-center p-10 space-y-8 min-h-[400px]">
            <div className="relative">
                <motion.div
                    animate={{ rotate: 360 }}
                    transition={{ duration: 4, repeat: Infinity, ease: "linear" }}
                    className="w-24 h-24 border-4 border-t-accent border-r-transparent border-b-accent border-l-transparent rounded-full"
                />
                <motion.div
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    className="absolute inset-0 flex items-center justify-center text-ai-glow"
                >
                    <CurrentIcon size={40} />
                </motion.div>
            </div>

            <div className="h-16 flex flex-col items-center justify-center overflow-hidden">
                <AnimatePresence mode='wait'>
                    <motion.h3
                        key={currentStep}
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -20 }}
                        className="text-xl font-heading text-parchment tracking-wider text-center"
                    >
                        {steps[currentStep].text}
                    </motion.h3>
                </AnimatePresence>
            </div>
            
            <div className="w-64 h-1 bg-primary-light rounded-full overflow-hidden border border-accent/20">
                <motion.div 
                    className="h-full bg-accent-glow"
                    initial={{ width: "0%" }}
                    animate={{ width: `${((currentStep + 1) / steps.length) * 100}%` }}
                    transition={{ duration: 0.5 }}
                />
            </div>
        </div>
    );
};

export default LoadingScreen;

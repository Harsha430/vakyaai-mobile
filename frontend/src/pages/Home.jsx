import React, { useState } from 'react';
import { motion } from 'framer-motion';
import PitchInput from '../components/PitchInput';
import LoadingScreen from '../components/LoadingScreen';
import ResultsDashboard from '../components/ResultsDashboard';
import { analyzePitch } from '../services/api';

const Home = () => {
    const [status, setStatus] = useState('idle'); // idle, loading, success, error
    const [analysisData, setAnalysisData] = useState(null);
    const [errorMsg, setErrorMsg] = useState("");

    const handleAnalyze = async (pitchText, audience) => {
        setStatus('loading');
        setErrorMsg("");
        
        try {
            const data = await analyzePitch(pitchText, audience);
            // Flatten the nested structure from backend: { analysis: {...}, original_pitch: ... }
            // to match ResultsDashboard expectations
            setAnalysisData({
                ...data.analysis,
                original_pitch: data.original_pitch
            });
            setStatus('success');
        } catch (error) {
            console.error("Analysis Failed", error);
            setStatus('error');
            setErrorMsg("Our scribes faced an interruption. Please try again.");
        }
    };

    const resetAnalysis = () => {
        setStatus('idle');
        setAnalysisData(null);
    };

    return (
        <div className="min-h-screen px-4 pt-24 md:pt-32 pb-16 relative z-10 font-body">
            {/* Background Atmosphere */}
            <div className="fixed inset-0 pointer-events-none overflow-hidden h-screen w-screen -z-10">
                <div className="absolute top-[20%] right-[10%] w-[300px] md:w-[500px] h-[300px] md:h-[500px] bg-accent/5 blur-[80px] md:blur-[120px] rounded-full animate-pulse"></div>
                <div className="absolute bottom-[10%] left-[5%] w-[250px] md:w-[400px] h-[250px] md:h-[400px] bg-accent-light/5 blur-[70px] md:blur-[100px] rounded-full"></div>
            </div>

            {/* Header */}
            <motion.header 
                initial={{ opacity: 0, y: -20 }}
                animate={{ opacity: 1, y: 0 }}
                className="text-center mb-10 md:mb-16 space-y-4 md:space-y-6"
            >
                <div className="inline-block p-1 px-3 rounded-full bg-accent/10 border border-accent/20 text-accent text-[8px] md:text-[10px] font-bold uppercase tracking-[0.2em] mb-2 md:mb-4">
                    The Scroll of Vākya
                </div>
                <h1 className="text-4xl sm:text-5xl md:text-8xl font-heading text-transparent bg-clip-text bg-gradient-to-b from-parchment via-parchment to-accent/50 leading-[1.1]">
                    Refine Your <br className="hidden sm:block"/> Command
                </h1>
                <p className="text-base md:text-xl text-parchment/40 font-medium max-w-2xl mx-auto italic px-4">
                    "Transform raw thought into technical legacy through the lens of AI wisdom."
                </p>
            </motion.header>

            {/* Content Switcher */}
            <main className="max-w-5xl mx-auto">
                {status === 'idle' && (
                    <PitchInput onSubmit={handleAnalyze} isLoading={false} />
                )}

                {status === 'loading' && (
                    <LoadingScreen />
                )}

                {status === 'success' && (
                    <div className="space-y-8">
                        <button 
                            onClick={resetAnalysis}
                            className="block mx-auto text-sm text-accent/60 hover:text-accent underline transition-colors"
                        >
                            &larr; Analyze Another Pitch
                        </button>
                        <ResultsDashboard analysis={analysisData} />
                    </div>
                )}

                {status === 'error' && (
                    <div className="text-center space-y-6">
                         <div className="text-red-400 font-heading text-xl">
                            {errorMsg}
                         </div>
                         <button 
                            onClick={() => setStatus('idle')}
                            className="bg-primary-light border border-accent/20 px-6 py-2 rounded-full text-parchment hover:bg-primary-light/80"
                        >
                            Try Again
                         </button>
                    </div>
                )}
            </main>

            {/* Simple Footer */}
            <footer className="text-center text-parchment/20 text-[10px] md:text-sm mt-16 md:mt-32 font-mono">
                Running in AGENT_MODE_EXECUTION • VākyaAI System v1.0
            </footer>
        </div>
    );
};

export default Home;

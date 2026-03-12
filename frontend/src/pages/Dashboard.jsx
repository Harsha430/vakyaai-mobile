import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { getMyAnalyses } from '../services/api';
import { useAuth } from '../context/AuthContext';
import { 
    BookOpen, TrendingUp, Award, Calendar, ChevronRight, 
    Search, Filter, X 
} from 'lucide-react';
import { Link } from 'react-router-dom';
import ResultsDashboard from '../components/ResultsDashboard';

const Dashboard = () => {
    const [analyses, setAnalyses] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedAnalysis, setSelectedAnalysis] = useState(null);
    const { user } = useAuth();

    useEffect(() => {
        if (selectedAnalysis) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = 'unset';
        }
        return () => { document.body.style.overflow = 'unset'; };
    }, [selectedAnalysis]);

    useEffect(() => {
        const fetchAnalyses = async () => {
            try {
                const data = await getMyAnalyses();
                setAnalyses(data);
            } catch (err) {
                console.error("Failed to fetch analyses", err);
            } finally {
                setLoading(false);
            }
        };
        fetchAnalyses();
    }, []);

    const filteredAnalyses = analyses.filter(a => 
        a.original_pitch.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const stats = [
        { label: 'Total Analyzed', value: analyses.length, icon: BookOpen, color: 'text-blue-400' },
        { label: 'Avg Scrutiny', value: analyses.length ? (analyses.reduce((acc, curr) => acc + curr.analysis.overall_score, 0) / analyses.length).toFixed(1) : 0, icon: TrendingUp, color: 'text-accent' },
        { label: 'Best Score', value: analyses.length ? Math.max(...analyses.map(a => a.analysis.overall_score)) : 0, icon: Award, color: 'text-green-400' },
    ];

    return (
        <div className="min-h-screen bg-primary pt-24 md:pt-32 pb-20 px-4 md:px-6 font-body">
            <div className="max-w-6xl mx-auto space-y-8 md:space-y-12">
                {/* Header Section */}
                <div className="flex flex-col md:flex-row md:items-end justify-between gap-6">
                    <div>
                        <motion.h1 
                            initial={{ opacity: 0, x: -20 }}
                            animate={{ opacity: 1, x: 0 }}
                            className="text-3xl md:text-5xl font-heading text-parchment mb-2 tracking-tight"
                        >
                            Namaste, {user?.sub?.split('@')[0]}
                        </motion.h1>
                        <p className="text-parchment/60 font-medium text-base md:text-lg">Your repository of enlightened technical pitches.</p>
                    </div>
                    <Link to="/" className="w-full md:w-fit bg-accent hover:bg-accent-light text-primary font-bold px-8 py-4 rounded-xl transition-all shadow-lg shadow-accent/20 flex items-center justify-center gap-2 active:scale-95">
                        New Analysis <ChevronRight className="w-5 h-5" />
                    </Link>
                </div>

                {/* Stats Grid */}
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 md:gap-6">
                    {stats.map((stat, idx) => (
                        <motion.div 
                            key={stat.label}
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: idx * 0.1 }}
                            className="glass-card p-6 md:p-8 rounded-2xl border border-accent/10 bg-white/5 flex items-center gap-4 md:gap-6"
                        >
                            <div className={`p-3 md:p-4 bg-white/5 rounded-xl ${stat.color} shrink-0`}>
                                <stat.icon className="w-6 h-6 md:w-8 md:h-8" />
                            </div>
                            <div>
                                <p className="text-parchment/40 text-[10px] md:text-sm font-bold uppercase tracking-widest">{stat.label}</p>
                                <p className="text-xl md:text-3xl text-parchment font-heading mt-0.5 md:mt-1">{stat.value}</p>
                            </div>
                        </motion.div>
                    ))}
                </div>

                {/* Main Content Area */}
                <div className="space-y-6">
                    <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                        <h2 className="text-xl md:text-2xl font-heading text-parchment tracking-tight">Recent Manuscripts</h2>
                        <div className="relative group w-full md:min-w-[300px]">
                            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 md:w-5 md:h-5 text-parchment/20 group-focus-within:text-accent transition-colors" />
                            <input 
                                type="text"
                                placeholder="Search repository..."
                                className="w-full bg-white/5 border border-accent/10 rounded-xl py-3 pl-10 md:pl-12 pr-4 text-parchment text-sm md:text-base placeholder:text-parchment/20 focus:outline-none focus:border-accent/40 transition-all font-medium"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                            />
                        </div>
                    </div>

                    {loading ? (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            {[1, 2, 3, 4].map(n => (
                                <div key={n} className="h-48 rounded-2xl bg-white/5 animate-pulse border border-accent/5"></div>
                            ))}
                        </div>
                    ) : filteredAnalyses.length > 0 ? (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            {filteredAnalyses.map((analysis, idx) => (
                                <motion.div 
                                    key={analysis.id}
                                    initial={{ opacity: 0, scale: 0.95 }}
                                    animate={{ opacity: 1, scale: 1 }}
                                    transition={{ delay: idx * 0.05 }}
                                    className="glass-card p-5 md:p-6 rounded-2xl border border-accent/10 bg-white/5 hover:bg-white/10 transition-all group flex flex-col justify-between"
                                >
                                    <div>
                                        <div className="flex items-start justify-between mb-3 md:mb-4">
                                            <div className="p-1.5 md:p-2 bg-accent/10 rounded-lg text-accent text-[10px] font-bold flex items-center gap-1">
                                                <Calendar className="w-3 h-3" />
                                                {new Date(analysis.created_at).toLocaleDateString()}
                                            </div>
                                            <div className="text-xl md:text-2xl font-heading text-accent">{analysis.analysis.overall_score}</div>
                                        </div>
                                        <p className="text-parchment/90 font-medium line-clamp-2 italic mb-3 md:mb-4 text-sm md:text-base">"{analysis.original_pitch}"</p>
                                    </div>
                                    <div className="flex items-center justify-between pt-4 border-t border-accent/5">
                                        <div className="flex -space-x-2">
                                            <div className="w-5 h-5 md:w-6 md:h-6 rounded-full bg-accent-light/20 border border-accent/20"></div>
                                            <div className="w-5 h-5 md:w-6 md:h-6 rounded-full bg-accent/20 border border-accent/20"></div>
                                        </div>
                                        <button 
                                            onClick={() => setSelectedAnalysis(analysis)}
                                            className="text-accent group-hover:text-accent-light flex items-center gap-1 font-bold text-xs md:text-sm transition-colors"
                                        >
                                            View Scroll <ChevronRight className="w-3 h-3 md:w-4 md:h-4" />
                                        </button>
                                    </div>
                                </motion.div>
                            ))}
                        </div>
                    ) : (
                        <div className="glass-card p-20 rounded-3xl border border-accent/10 bg-white/5 text-center">
                            <BookOpen className="w-16 h-16 text-accent/20 mx-auto mb-6" />
                            <h3 className="text-2xl font-heading text-parchment tracking-tight">The archives are empty.</h3>
                            <p className="text-parchment/40 max-w-sm mx-auto mb-8 font-medium">Begin your first analysis to unlock the repository's wisdom.</p>
                            <Link to="/" className="text-accent underline underline-offset-4 font-bold">Initiate first analysis</Link>
                        </div>
                    )}
                </div>
            </div>

            {/* Analysis Detail Modal */}
            <AnimatePresence>
                {selectedAnalysis && (
                    <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 md:p-8">
                        <motion.div 
                            initial={{ opacity: 0 }}
                            animate={{ opacity: 1 }}
                            exit={{ opacity: 0 }}
                            onClick={() => setSelectedAnalysis(null)}
                            className="absolute inset-0 bg-primary/95 backdrop-blur-xl"
                        />
                        <motion.div 
                            initial={{ opacity: 0, y: 50, scale: 0.95 }}
                            animate={{ opacity: 1, y: 0, scale: 1 }}
                            exit={{ opacity: 0, y: 50, scale: 0.95 }}
                            className="relative w-full max-w-6xl h-full md:h-auto md:max-h-[90vh] overflow-hidden flex flex-col manuscript-container bg-primary border-accent/20 shadow-[0_0_100px_rgba(0,0,0,0.5)] rounded-none md:rounded-2xl"
                            onClick={(e) => e.stopPropagation()}
                        >
                            <div className="flex-shrink-0 flex justify-between items-center p-4 md:p-6 border-b border-white/5 bg-primary/80 backdrop-blur-md">
                                <div className="flex items-center gap-3 md:gap-4 text-left">
                                    <div className="p-1.5 md:p-2 bg-accent/10 rounded-lg text-accent text-[8px] md:text-xs font-bold uppercase tracking-widest">
                                        Archive ID: {selectedAnalysis.id.slice(-6)}
                                    </div>
                                    <span className="text-parchment/40 text-[10px] md:text-xs">{new Date(selectedAnalysis.created_at).toLocaleString()}</span>
                                </div>
                                <button 
                                    onClick={() => setSelectedAnalysis(null)}
                                    className="p-1.5 md:p-2 hover:bg-white/5 rounded-full text-parchment/40 hover:text-parchment transition-all"
                                >
                                    <X size={20} className="md:w-6 md:h-6" />
                                </button>
                            </div>
                            <div className="p-4 md:p-8 overflow-y-auto flex-1 custom-scrollbar">
                                <ResultsDashboard 
                                    analysis={{
                                        ...selectedAnalysis.analysis,
                                        original_pitch: selectedAnalysis.original_pitch
                                    }} 
                                />
                            </div>
                        </motion.div>
                    </div>
                )}
            </AnimatePresence>
        </div>
    );
};

export default Dashboard;

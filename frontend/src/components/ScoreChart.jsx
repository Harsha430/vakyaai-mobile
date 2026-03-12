import React from 'react';
import {
  Radar,
  RadarChart,
  PolarGrid,
  PolarAngleAxis,
  PolarRadiusAxis,
  ResponsiveContainer,
  Tooltip
} from 'recharts';

const ScoreChart = ({ scores }) => {
    if (!scores) return null;

    // Transform scores object to array for Recharts
    // Expected keys: clarity, problem_definition, etc.
    const data = Object.keys(scores).map(key => ({
        subject: key.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase()),
        A: scores[key],
        fullMark: 10,
    }));

    return (
        <div className="w-full h-[320px] flex items-center justify-center p-4 relative block">
            <ResponsiveContainer width="100%" height="100%">
                <RadarChart cx="50%" cy="50%" outerRadius="75%" data={data}>
                    <PolarGrid stroke="#F5F5DC" strokeOpacity={0.1} />
                    <PolarAngleAxis 
                        dataKey="subject" 
                        tick={{ fill: '#F59E0B', fontSize: 10, fontWeight: 'medium' }} 
                    />
                    <PolarRadiusAxis 
                        angle={30} 
                        domain={[0, 10]} 
                        tick={false} 
                        axisLine={false}
                    />
                    <Radar
                        name="Pitch Score"
                        dataKey="A"
                        stroke="#2DD4BF"
                        strokeWidth={1.5}
                        fill="#2DD4BF"
                        fillOpacity={0.2}
                    />
                    <Tooltip 
                        contentStyle={{ 
                            backgroundColor: 'rgba(30, 41, 59, 0.9)', 
                            borderColor: 'rgba(245, 158, 11, 0.2)', 
                            color: '#F5F5DC',
                            borderRadius: '12px',
                            backdropFilter: 'blur(8px)',
                            border: '1px solid rgba(255,255,255,0.1)'
                        }}
                        itemStyle={{ color: '#2DD4BF', fontSize: '12px' }}
                    />
                </RadarChart>
            </ResponsiveContainer>
        </div>
    );
};

export default ScoreChart;

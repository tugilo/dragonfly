import React, { useMemo } from 'react';
import { Box, Divider, Typography } from '@mui/material';
import ReactMarkdown from 'react-markdown';

export function createMarkdownComponents(dense) {
    const variant = dense ? 'caption' : 'body2';
    const codeFontSize = dense ? '0.68rem' : '0.78rem';

    const heading = ({ children }) => (
        <Typography
            component="div"
            sx={{
                fontWeight: 700,
                fontSize: dense ? '0.72rem' : '0.95rem',
                mt: dense ? 0.65 : 1,
                mb: dense ? 0.25 : 0.5,
                lineHeight: 1.35,
                '&:first-of-type': { mt: 0 },
            }}
        >
            {children}
        </Typography>
    );

    return {
        p: ({ children }) => (
            <Typography variant={variant} component="p" sx={{ mb: 0.65, mt: 0, '&:last-child': { mb: 0 } }}>
                {children}
            </Typography>
        ),
        h1: heading,
        h2: heading,
        h3: heading,
        h4: heading,
        h5: heading,
        h6: heading,
        ul: ({ children }) => (
            <Box component="ul" sx={{ m: 0, mb: 0.65, pl: 2.25, listStyleType: 'disc', '&:last-child': { mb: 0 } }}>
                {children}
            </Box>
        ),
        ol: ({ children }) => (
            <Box component="ol" sx={{ m: 0, mb: 0.65, pl: 2.25, listStyleType: 'decimal', '&:last-child': { mb: 0 } }}>
                {children}
            </Box>
        ),
        li: ({ children }) => (
            <Typography component="li" variant={variant} sx={{ display: 'list-item', mb: 0.2 }}>
                {children}
            </Typography>
        ),
        a: ({ href, children }) => (
            <Box
                component="a"
                href={href}
                target="_blank"
                rel="noopener noreferrer"
                sx={{ color: 'primary.main', textDecoration: 'underline', wordBreak: 'break-all' }}
            >
                {children}
            </Box>
        ),
        blockquote: ({ children }) => (
            <Box
                component="blockquote"
                sx={{
                    borderLeft: '3px solid',
                    borderColor: 'divider',
                    pl: 1.25,
                    my: 0.65,
                    mx: 0,
                    color: 'text.secondary',
                }}
            >
                {children}
            </Box>
        ),
        hr: () => <Divider sx={{ my: dense ? 0.75 : 1.25 }} />,
        pre: ({ children }) => (
            <Box
                component="pre"
                sx={{
                    m: 0,
                    my: 0.65,
                    p: dense ? 0.65 : 1,
                    bgcolor: 'grey.100',
                    borderRadius: 1,
                    overflow: 'auto',
                    fontFamily: 'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace',
                    fontSize: codeFontSize,
                    maxWidth: '100%',
                }}
            >
                {children}
            </Box>
        ),
        code: ({ inline, children }) => {
            if (inline) {
                return (
                    <Typography
                        component="code"
                        variant="inherit"
                        sx={{
                            bgcolor: 'action.hover',
                            px: 0.35,
                            py: 0.05,
                            borderRadius: 0.5,
                            fontFamily: 'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace',
                            fontSize: '0.9em',
                        }}
                    >
                        {children}
                    </Typography>
                );
            }
            return (
                <Box
                    component="code"
                    sx={{
                        fontFamily: 'inherit',
                        fontSize: 'inherit',
                        whiteSpace: 'pre-wrap',
                        wordBreak: 'break-word',
                        display: 'block',
                    }}
                >
                    {children}
                </Box>
            );
        },
        table: ({ children }) => (
            <Box sx={{ overflowX: 'auto', my: 0.65 }}>
                <Box component="table" sx={{ width: '100%', borderCollapse: 'collapse', fontSize: dense ? '0.68rem' : '0.78rem' }}>
                    {children}
                </Box>
            </Box>
        ),
        th: ({ children }) => (
            <Box component="th" sx={{ border: 1, borderColor: 'divider', px: 0.75, py: 0.35, bgcolor: 'action.hover', textAlign: 'left' }}>
                {children}
            </Box>
        ),
        td: ({ children }) => (
            <Box component="td" sx={{ border: 1, borderColor: 'divider', px: 0.75, py: 0.35, verticalAlign: 'top' }}>
                {children}
            </Box>
        ),
    };
}

export function MarkdownView({ markdown, dense = false }) {
    const components = useMemo(() => createMarkdownComponents(dense), [dense]);
    return <ReactMarkdown components={components}>{markdown}</ReactMarkdown>;
}

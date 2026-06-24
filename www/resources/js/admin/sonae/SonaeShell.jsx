import React from 'react';
import { Outlet } from 'react-router-dom';
import { Alert, Box, CircularProgress, Container, Typography } from '@mui/material';
import { SonaeChapterProvider, useSonaeChapter } from './SonaeChapterContext';

function SonaeShellInner() {
    const { loading, error } = useSonaeChapter();

    if (loading) {
        return (
            <Box sx={{ display: 'flex', justifyContent: 'center', py: 8 }}>
                <CircularProgress />
            </Box>
        );
    }

    if (error) {
        return (
            <Container maxWidth="md" sx={{ py: 4 }}>
                <Typography variant="h5" gutterBottom>
                    SONAE
                </Typography>
                <Alert severity="warning">{error.message}</Alert>
            </Container>
        );
    }

    return <Outlet />;
}

export default function SonaeShell() {
    return (
        <SonaeChapterProvider>
            <SonaeShellInner />
        </SonaeChapterProvider>
    );
}

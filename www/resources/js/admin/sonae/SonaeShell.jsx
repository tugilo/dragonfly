import React from 'react';
import { Outlet } from 'react-router-dom';
import { Alert, Box, Button, CircularProgress, Container, Stack, Typography } from '@mui/material';
import { SonaeChapterProvider, useSonaeChapter } from './SonaeChapterContext';

function SonaeShellInner() {
    const { loading, error, bootstrapRequired, bootstrapping, bootstrap, workspaceName } = useSonaeChapter();

    if (loading) {
        return (
            <Box sx={{ display: 'flex', justifyContent: 'center', py: 8 }}>
                <CircularProgress />
            </Box>
        );
    }

    if (bootstrapRequired) {
        return (
            <Container maxWidth="md" sx={{ py: 4 }}>
                <Typography variant="h5" gutterBottom>
                    SONAE
                </Typography>
                <Alert severity="info" sx={{ mb: 2 }}>
                    {workspaceName ?? 'このチャプター'} の SONAE 設定が未作成です。Religo メンバーから名簿を同期するため、初回セットアップを実行してください。
                </Alert>
                {error ? <Alert severity="error" sx={{ mb: 2 }}>{error.message}</Alert> : null}
                <Button variant="contained" disabled={bootstrapping} onClick={bootstrap}>
                    {bootstrapping ? 'セットアップ中…' : 'SONAE をセットアップ'}
                </Button>
            </Container>
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

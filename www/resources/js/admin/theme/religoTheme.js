/**
 * Religo 管理画面の MUI Theme（SSOT: docs/SSOT/ADMIN_UI_THEME_SSOT.md）
 * 適用は app.jsx の Admin に theme={religoTheme} で一箇所のみ。
 */
import { createTheme } from '@mui/material/styles';

export const religoTheme = createTheme({
    typography: {
        fontFamily: [
            '-apple-system',
            'BlinkMacSystemFont',
            '"Segoe UI"',
            'Roboto',
            '"Helvetica Neue"',
            'Arial',
            'sans-serif',
        ].join(','),
        h6: {
            fontSize: '1.25rem',
            fontWeight: 600,
            lineHeight: 1.3,
        },
        subtitle1: {
            fontSize: '1rem',
            fontWeight: 600,
            lineHeight: 1.5,
        },
        body2: {
            fontSize: '0.875rem',
            fontWeight: 400,
            lineHeight: 1.43,
        },
        caption: {
            fontSize: '0.75rem',
            fontWeight: 400,
            lineHeight: 1.66,
        },
    },
    shape: {
        borderRadius: 8,
    },
    components: {
        MuiCard: {
            defaultProps: {
                variant: 'outlined',
            },
            styleOverrides: {
                root: {
                    borderRadius: 8,
                    boxShadow: 'none',
                },
            },
        },
        MuiButton: {
            styleOverrides: {
                root: {
                    textTransform: 'none',
                },
            },
        },
        MuiTextField: {
            defaultProps: {
                variant: 'outlined',
                size: 'small',
                margin: 'dense',
            },
        },
        MuiFormControl: {
            defaultProps: {
                variant: 'outlined',
                size: 'small',
                margin: 'dense',
            },
        },
        MuiInputBase: {
            styleOverrides: {
                root: {
                    '&.Mui-focused .MuiOutlinedInput-notchedOutline': {
                        borderWidth: 1,
                    },
                },
            },
        },
        MuiChip: {
            defaultProps: {
                size: 'small',
            },
        },
        MuiAlert: {
            defaultProps: {
                variant: 'standard',
            },
        },
        MuiAutocomplete: {
            defaultProps: {
                size: 'small',
            },
        },
    },
});

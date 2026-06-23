import React from 'react';
import { Chip } from '@mui/material';
import { oneToOneNonBniChipLabel } from '../utils/memberEnrollmentType';

/**
 * 1to1 履歴で相手が BNI 在籍メンバーでないときの Chip。
 */
export function OneToOneEnrollmentChip({ record, sx }) {
    const label = oneToOneNonBniChipLabel(record ?? {});
    if (!label) {
        return null;
    }
    return (
        <Chip
            size="small"
            label={label}
            color="secondary"
            variant="outlined"
            sx={{ height: 22, mt: 0.25, ...sx }}
        />
    );
}

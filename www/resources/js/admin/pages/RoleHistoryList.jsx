import React from 'react';
import { List, Datagrid, TextField, FunctionField, TopToolbar, Button } from 'react-admin';
import { Link } from 'react-router-dom';
import { Chip } from '@mui/material';

/**
 * Role History 一覧。SSOT: religo-admin-mock.html (pg-role-history).
 * API 未整備のため dataProvider がスタブを返す。UI のみモック準拠。
 */
const ROLE_CHIP_COLOR = {
    プレジ: 'warning',
    バイス: 'secondary',
    書記: 'success',
    会計: 'info',
    メンター: 'secondary',
    エドコ: 'info',
    メンバー: 'default',
};

function RoleHistoryActions() {
    return (
        <TopToolbar>
            <Button component={Link} to="/connections" variant="outlined" size="small">🗺 Connectionsへ</Button>
            <Button variant="contained" size="small" disabled>＋ 役職追加（Coming soon）</Button>
        </TopToolbar>
    );
}

export function RoleHistoryList() {
    return (
        <List
            title="Role History"
            actions={<RoleHistoryActions />}
            perPage={25}
            sort={{ field: 'start', order: 'DESC' }}
        >
            <Datagrid rowClick={false}>
                <TextField source="member" label="メンバー" />
                <FunctionField
                    label="役職"
                    render={(r) => (
                        <Chip
                            label={r.role}
                            size="small"
                            color={ROLE_CHIP_COLOR[r.role] || 'default'}
                            variant="outlined"
                        />
                    )}
                />
                <TextField source="start" label="任期開始" />
                <FunctionField
                    label="任期終了"
                    render={(r) => (r.end ? r.end : '—')}
                />
                <FunctionField
                    label="状態"
                    render={(r) => (
                        r.current ? (
                            <Chip label="現任" size="small" color="success" variant="outlined" />
                        ) : (
                            <Chip label="終了" size="small" variant="outlined" />
                        )
                    )}
                />
                <FunctionField
                    label="Actions"
                    render={() => (
                        <Button size="small" variant="outlined" disabled>✏️ 編集</Button>
                    )}
                />
            </Datagrid>
        </List>
    );
}

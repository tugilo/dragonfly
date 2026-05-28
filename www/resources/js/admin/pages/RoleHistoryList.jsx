import React, { useEffect, useState } from 'react';
import {
    List,
    Datagrid,
    TextField,
    FunctionField,
    TopToolbar,
    Button,
    Filter,
    SelectInput,
    TextInput,
    useDataProvider,
} from 'react-admin';
import { Link } from 'react-router-dom';
import { Chip } from '@mui/material';

/**
 * Role History 一覧。GET /api/member-roles を利用。フィルタ: role_id, member_id, from, to.
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
            <Button component={Link} to="/roles/create" variant="contained" size="small">＋ 役職追加</Button>
        </TopToolbar>
    );
}

function RoleHistoryFilters(props) {
    const [roleChoices, setRoleChoices] = useState([]);
    const [memberChoices, setMemberChoices] = useState([]);
    const dataProvider = useDataProvider();

    useEffect(() => {
        dataProvider.getList('roles', { pagination: { page: 1, perPage: 100 }, sort: { field: 'name', order: 'ASC' }, filter: {} })
            .then((r) => setRoleChoices((r.data || []).map((x) => ({ id: x.id, name: x.name }))));
        dataProvider.getList('members', { pagination: { page: 1, perPage: 500 }, sort: { field: 'id', order: 'ASC' }, filter: {} })
            .then((r) => setMemberChoices((r.data || []).map((x) => ({ id: x.id, name: x.name || `#${x.id}` }))));
    }, [dataProvider]);

    return (
        <Filter {...props}>
            <SelectInput source="role_id" label="役職" choices={roleChoices} alwaysOn />
            <SelectInput source="member_id" label="メンバー" choices={memberChoices} alwaysOn />
            <TextInput source="from" label="from (日付)" type="date" />
            <TextInput source="to" label="to (日付)" type="date" />
        </Filter>
    );
}

export function RoleHistoryList() {
    return (
        <List
            title="Role History"
            actions={<RoleHistoryActions />}
            perPage={25}
            sort={{ field: 'start', order: 'DESC' }}
            filters={[<RoleHistoryFilters key="filters" />]}
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
            </Datagrid>
        </List>
    );
}

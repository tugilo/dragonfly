import React, { useEffect, useState } from 'react';
import { SelectInput, FormDataConsumer, required } from 'react-admin';

async function fetchJson(url) {
    const res = await fetch(url, { headers: { Accept: 'application/json' } });
    if (!res.ok) throw new Error(`API ${res.status}`);
    return res.json();
}

/**
 * Owner（自分）に連動した相手メンバー一覧（GET /api/dragonfly/members?owner_member_id=）.
 */
function ScopedTargetSelect({ ownerMemberId }) {
    const [choices, setChoices] = useState([]);

    useEffect(() => {
        if (ownerMemberId == null || ownerMemberId === '') {
            setChoices([]);
            return;
        }
        let cancelled = false;
        fetchJson(`/api/dragonfly/members?owner_member_id=${encodeURIComponent(String(ownerMemberId))}`)
            .then((arr) => {
                if (cancelled || !Array.isArray(arr)) return;
                setChoices(
                    arr.map((m) => ({
                        id: m.id,
                        name: `${m.display_no != null ? `#${m.display_no} ` : ''}${m.name}`.trim() || `#${m.id}`,
                    }))
                );
            })
            .catch(() => {
                if (!cancelled) setChoices([]);
            });
        return () => {
            cancelled = true;
        };
    }, [ownerMemberId]);

    if (ownerMemberId == null || ownerMemberId === '') {
        return (
            <SelectInput
                source="target_member_id"
                label="相手"
                choices={[]}
                emptyText="先に Owner（自分）を選択してください"
                validate={[required()]}
            />
        );
    }

    return <SelectInput source="target_member_id" label="相手" choices={choices} validate={[required()]} />;
}

/** SimpleForm 内: owner_member_id の値に応じて相手候補を loaded */
export function OwnerScopedTargetSelect() {
    return (
        <FormDataConsumer>{({ formData }) => <ScopedTargetSelect ownerMemberId={formData?.owner_member_id} />}</FormDataConsumer>
    );
}

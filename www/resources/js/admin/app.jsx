import React from 'react';
import { createRoot } from 'react-dom/client';
import { Admin, Resource } from 'react-admin';
import { dragonflyDataProvider } from './dataProvider';
import DragonFlyBoard from './pages/DragonFlyBoard';
import { ReligoLayout } from './ReligoLayout';
import { MembersPlaceholder } from './pages/MembersPlaceholder';
import { MeetingsPlaceholder } from './pages/MeetingsPlaceholder';
import { OneToOnesPlaceholder } from './pages/OneToOnesPlaceholder';

function DummyList() {
    console.log('[Admin] DummyList mounted — check Network/Console for getList flags API');
    return (
        <div style={{ padding: 16 }}>
            Flags list (API 疎通確認: Console に getList ログが出ます)
        </div>
    );
}

const root = document.getElementById('admin-root');
if (root) {
    createRoot(root).render(
        <Admin dataProvider={dragonflyDataProvider} layout={ReligoLayout} dashboard={DragonFlyBoard}>
            <Resource name="dragonflyFlags" list={DummyList} options={{ label: 'Flags' }} />
            <Resource name="members" list={MembersPlaceholder} options={{ label: 'Members（メンバー）' }} />
            <Resource name="meetings" list={MeetingsPlaceholder} options={{ label: 'Meetings（例会）' }} />
            <Resource name="one-to-ones" list={OneToOnesPlaceholder} options={{ label: '1 to 1（予定・履歴）' }} />
        </Admin>
    );
}

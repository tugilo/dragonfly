import { createRoot } from 'react-dom/client';
import { Admin, Resource } from 'react-admin';
import { dragonflyDataProvider } from './dataProvider';

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
        <Admin dataProvider={dragonflyDataProvider}>
            <Resource name="dragonflyFlags" list={DummyList} />
        </Admin>
    );
}

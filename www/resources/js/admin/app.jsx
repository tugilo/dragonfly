import { createRoot } from 'react-dom/client';
import { Admin } from 'react-admin';

const minimalDataProvider = {
    getList: () => Promise.resolve({ data: [], total: 0 }),
    getOne: () => Promise.resolve({ data: {} }),
    getMany: () => Promise.resolve({ data: [] }),
    getManyReference: () => Promise.resolve({ data: [], total: 0 }),
    create: () => Promise.resolve({ data: {} }),
    update: () => Promise.resolve({ data: {} }),
    updateMany: () => Promise.resolve({ data: [] }),
    delete: () => Promise.resolve({ data: {} }),
    deleteMany: () => Promise.resolve({ data: [] }),
};

const root = document.getElementById('admin-root');
if (root) {
    createRoot(root).render(
        <Admin dataProvider={minimalDataProvider} />
    );
}

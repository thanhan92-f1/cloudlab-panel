import React, { useEffect, useState } from 'react';
import axios from 'axios';

const PHPManager = () => {
    const [versions, setVersions] = useState([]);
    const [loading, setLoading] = useState(false);
    const [alert, setAlert] = useState(null);
    const [newVersion, setNewVersion] = useState('');

    const fetchVersions = async () => {
        setLoading(true);
        try {
            const res = await axios.get('/php/get-versions');
            setVersions(res.data);
        } catch (e) {
            setAlert({ type: 'error', message: 'Failed to load PHP versions' });
        }
        setLoading(false);
    };

    useEffect(() => {
        fetchVersions();
    }, []);

    const handleInstall = async () => {
        if (!newVersion) return setAlert({ type: 'error', message: 'Please enter a PHP version' });
        setLoading(true);
        try {
            const res = await axios.post('/php/install', { version: newVersion });
            setAlert({ type: res.data.status, message: res.data.message });
            fetchVersions();
        } catch (e) {
            setAlert({ type: 'error', message: 'Install failed' });
        }
        setLoading(false);
    };

    const handleUpdate = async (version) => {
        setLoading(true);
        try {
            const res = await axios.post('/php/update', { version });
            setAlert({ type: res.data.status, message: res.data.message });
            fetchVersions();
        } catch (e) {
            setAlert({ type: 'error', message: 'Update failed' });
        }
        setLoading(false);
    };

    const handleRemove = async (version) => {
        if (!window.confirm(`Remove PHP ${version}?`)) return;
        setLoading(true);
        try {
            const res = await axios.post('/php/remove', { version });
            setAlert({ type: res.data.status, message: res.data.message });
            fetchVersions();
        } catch (e) {
            setAlert({ type: 'error', message: 'Remove failed' });
        }
        setLoading(false);
    };

    return (
        <div className="container mx-auto p-4">
            <h1 className="text-2xl font-bold mb-4">PHP Manager</h1>
            {alert && (
                <div className={`mb-4 p-2 rounded ${alert.type === 'success' ? 'bg-green-200 text-green-800' : 'bg-red-200 text-red-800'}`}>{alert.message}</div>
            )}
            <table className="min-w-full bg-white border mb-4">
                <thead>
                    <tr>
                        <th className="py-2 px-4 border-b">Version</th>
                        <th className="py-2 px-4 border-b">Status</th>
                        <th className="py-2 px-4 border-b">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {versions.map(row => (
                        <tr key={row.version}>
                            <td className="py-2 px-4 border-b">{row.version}</td>
                            <td className="py-2 px-4 border-b">{row.active ? 'Active' : 'Inactive'}</td>
                            <td className="py-2 px-4 border-b">
                                <button onClick={() => handleUpdate(row.version)} className="bg-yellow-500 text-white px-2 py-1 rounded mr-2">Update</button>
                                <button onClick={() => handleRemove(row.version)} className="bg-red-500 text-white px-2 py-1 rounded">Remove</button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
            <div className="mt-6">
                <input type="text" value={newVersion} onChange={e => setNewVersion(e.target.value)} className="border px-2 py-1" placeholder="Enter PHP version (e.g. 8.2)" />
                <button onClick={handleInstall} className="bg-blue-500 text-white px-4 py-1 rounded ml-2">Install</button>
            </div>
            {loading && <div className="mt-4 text-gray-500">Processing...</div>}
        </div>
    );
};

export default PHPManager;

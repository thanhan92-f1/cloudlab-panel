<?php

namespace App\Http\Controllers;

use App\Models\PhpVersion;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use App\Services\PHPManagerService;

class PHPManagerController extends Controller
{
    protected $phpManager;

    public function __construct(PHPManagerService $phpManager)
    {
        $this->phpManager = $phpManager;
    }

    public function getVersions(): JsonResponse
    {
        $versions = PhpVersion::active()->get();
        return response()->json($versions);
    }

    public function install(Request $request)
    {
        $version = $request->input('version');
        $result = $this->phpManager->install($version);
        return response()->json($result);
    }

    public function update(Request $request)
    {
        $version = $request->input('version');
        $result = $this->phpManager->update($version);
        return response()->json($result);
    }

    public function remove(Request $request)
    {
        $version = $request->input('version');
        $result = $this->phpManager->remove($version);
        return response()->json($result);
    }
        public function showManager()
    {
        return inertia('PhpManage/Index');
    }
        public function getExtensions(Request $request)
    {
        $version = $request->query('version');
        $result = $this->phpManager->listExtensions($version);
        return response()->json(['extensions' => $result]);
    }

    public function installExtension(Request $request)
    {
        $version = $request->input('version');
        $extension = $request->input('extension');
        $result = $this->phpManager->installExtension($version, $extension);
        return response()->json($result);
    }

    public function removeExtension(Request $request)
    {
        $version = $request->input('version');
        $extension = $request->input('extension');
        $result = $this->phpManager->removeExtension($version, $extension);
        return response()->json($result);
    }
}

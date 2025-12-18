<?php

namespace App\Services;

class PHPManagerService
{
    public function install($version)
    {
        // TODO: Gọi shell script cài đặt PHP version
        // Ví dụ: shell_exec("sh /path/to/install-php.sh $version");
        return [
            'status' => 'success',
            'message' => "PHP $version installed (mocked)",
        ];
    }

    public function update($version)
    {
        // TODO: Gọi shell script cập nhật PHP version
        return [
            'status' => 'success',
            'message' => "PHP $version updated (mocked)",
        ];
    }

    public function remove($version)
    {
        // TODO: Gọi shell script gỡ bỏ PHP version
        return [
            'status' => 'success',
            'message' => "PHP $version removed (mocked)",
        ];
    }
        public function listExtensions($version)
    {
        $script = base_path('laranode-scripts/bin/php-ext.sh');
        $cmd = "$script $version list";
        $output = shell_exec($cmd);
        if (!$output) return [];
        $lines = explode("\n", trim($output));
        // Lọc bỏ các dòng không phải tên extension (giả định các dòng đầu là heading)
        $exts = array_filter($lines, function($line) {
            return $line && !preg_match('/\[PHP Manager\]/', $line);
        });
        return array_values($exts);
    }

    public function installExtension($version, $extension)
    {
        $script = base_path('laranode-scripts/bin/php-ext.sh');
        $cmd = "$script $version install $extension";
        $output = shell_exec($cmd);
        return [
            'status' => 'success',
            'message' => $output ?: "Extension $extension installed for PHP $version (mocked)",
        ];
    }

    public function removeExtension($version, $extension)
    {
        $script = base_path('laranode-scripts/bin/php-ext.sh');
        $cmd = "$script $version remove $extension";
        $output = shell_exec($cmd);
        return [
            'status' => 'success',
            'message' => $output ?: "Extension $extension removed for PHP $version (mocked)",
        ];
    }
}

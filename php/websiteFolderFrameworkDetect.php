<?php

$phpWebsitePath = $argv[1];
$framework      = false;

if (is_file($phpWebsitePath.'/wp-config.php')) {
    // Wordpress.
    require $phpWebsitePath.'/wp-includes/version.php';
    $framework = 'wordpress'.(explode('.', $wp_version)[0]);
}
else if (is_file($phpWebsitePath.'/sites/default/settings.php') && is_file($phpWebsitePath.'/includes/bootstrap.inc')) {
    // Drupal.
    require $phpWebsitePath.'/includes/bootstrap.inc';
    $framework = 'drupal'.(explode('.', VERSION)[0]);
}

if ($framework) {
    echo 'WEBSITE_FRAMEWORK="'.$framework.'";';
} else {
    $argv[1] = $phpWebsitePath.'/composer.json';
    # Parse composer.json file.
    # The script manage echo
    require "composerFrameworkDetect.php";
}

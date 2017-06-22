<?php

namespace Commands;

use GuzzleHttp\Client;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class PhpRedisVersion extends Command
{
    protected function configure()
    {
        $this->setName('version:php_redis');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $client = new Client();
        $content = $client->request('GET', 'https://pecl.php.net/package/redis');
        $content = (string) $content->getBody();

        preg_match('/"\/package\/redis\/((\d+\.?)+)"/', $content, $matches);

        $version = empty($matches[1]) ? null : $matches[1];
        $output->writeln($version);
    }
}
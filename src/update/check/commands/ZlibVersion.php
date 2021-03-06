<?php

namespace Commands;

use GuzzleHttp\Client;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class ZlibVersion extends Command
{
    protected function configure()
    {
        $this->setName('version:zlib');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $client = new Client();
        $content = $client->request('GET', 'http://zlib.net/');
        $content = (string) $content->getBody();

        preg_match('/<B> zlib ((\d+\.?)+)<\/B>/', $content, $matches);

        $version = empty($matches[1]) ? null : $matches[1];
        $output->writeln($version);
    }
}
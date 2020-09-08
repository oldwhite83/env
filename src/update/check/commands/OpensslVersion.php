<?php

namespace Commands;

use GuzzleHttp\Client;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class OpensslVersion extends Command
{
    protected function configure()
    {
        $this->setName('version:openssl');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $client = new Client();
        $content = $client->request('GET', 'https://www.openssl.org/source/');
        $content = (string) $content->getBody();

        preg_match('/(1\.0\..*?)\.tar\.gz/', $content, $matches);

        $version = empty($matches[1]) ? null : $matches[1];
        $output->writeln($version);
    }
}
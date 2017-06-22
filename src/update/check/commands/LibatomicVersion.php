<?php

namespace Commands;

use GuzzleHttp\Client;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class LibatomicVersion extends Command
{
    protected function configure()
    {
        $this->setName('version:libatomic');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $client = new Client();
        $content = $client->request('GET', 'http://www.hboehm.info/gc/');
        $content = (string) $content->getBody();

        preg_match('/libatomic_ops-((\d+\.?)+).tar.gz/', $content, $matches);

        $version = empty($matches[1]) ? null : $matches[1];
        $output->writeln($version);
    }
}
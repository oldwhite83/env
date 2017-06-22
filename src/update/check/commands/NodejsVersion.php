<?php

namespace Commands;

use GuzzleHttp\Client;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class NodejsVersion extends Command
{
    protected function configure()
    {
        $this->setName('version:nodejs');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $client = new Client();
        $content = $client->request('GET', 'https://nodejs.org/en/download/');
        $content = (string) $content->getBody();

        preg_match('/Latest LTS Version: <strong>v(.*?)<\/strong>/', $content, $matches);

        $version = empty($matches[1]) ? null : $matches[1];
        $output->writeln($version);
    }
}
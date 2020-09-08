<?php

namespace Commands;

use GuzzleHttp\Client;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class PhpVersion extends Command
{
    protected function configure()
    {
        $this->setName('version:php');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $client = new Client();
        $content = $client->request('GET', 'http://www.php.net/downloads.php');
        $content = (string) $content->getBody();

        preg_match('/<h3 id="v(.*)" class="title">/', $content, $matches);

        $version = empty($matches[1]) ? null : $matches[1];
        $output->writeln($version);
    }
}
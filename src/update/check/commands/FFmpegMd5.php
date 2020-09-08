<?php

namespace Commands;

use GuzzleHttp\Client;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class FFmpegMd5 extends Command
{
    protected function configure()
    {
        $this->setName('md5:ffmpeg');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $content = trim(file_get_contents('https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz.md5'));
        $md5 = explode(' ', $content)[0];

        $output->writeln($md5);
    }
}
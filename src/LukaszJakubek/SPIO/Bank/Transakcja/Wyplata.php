<?php
/**
 * Definicja transakcji wypłaty
 */

namespace LukaszJakubek\SPIO\Bank\Transakcja;

use LukaszJakubek\SPIO\Bank\Rachunek\RachunekInterface;

/**
 * Transakcja wypłaty
 *
 * @author Łukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
class Wyplata implements TransakcjaInterface
{
    /**
     * Rachunek którego dotyczy transakcja
     *
     * @var RachunekInterface
     */
    private $rachunek;

    /**
     * Wartość transakcji
     *
     * @var int
     */
    private $kwota = 0;

    /**
     * Status transakcji
     *
     * @var string
     */
    private $status = Status::FRESH;

    /**
     * Saldo po transakcji
     *
     * @var int
     */
    private $saldo = 0;

    /**
     * Konstruktor
     *
     * @param Rachunek $rachunek Rachunek którego dotyczy transakcja
     * @param int $kwota Wartość wypłaty
     */
    public function __construct(RachunekInterface $rachunek, $kwota)
    {
        $this->rachunek = $rachunek;
        $this->kwota = $kwota;
    }

    /**
     * Wykonuje transakcję
     *
     * @return bool
     */
    public function execute()
    {
        if ($this->status != Status::FRESH) {
            return false;
        }

        $this->status = Status::FAILED;
        if ($this->rachunek->getSaldo() + $this->rachunek->getDopuszczalnyDebet() >= $this->kwota) {
            $this->rachunek->setSaldo($this->rachunek->getSaldo() - $this->kwota);
            $this->status = Status::EXECUTED;
        }

        $this->saldo = $this->rachunek->getSaldo();
        $this->rachunek->addHistoria($this);

        return true;
    }

    /**
     * Zwraca status transakcji
     *
     * @return string
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * Cast to string
     *
     * @return string
     */
    public function __toString()
    {
        return sprintf('Wypłata [%s]: %.2d, saldo: %.2d', $this->status, $this->kwota, $this->saldo);
    }
}

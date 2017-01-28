<?php
/**
 * Definicja transakcji wpłaty
 */

namespace LukaszJakubek\SPIO\Bank\Transakcja;

use LukaszJakubek\SPIO\Bank\Rachunek\RachunekInterface;

/**
 * Transakcja wpłaty
 *
 * @author Łukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
class Wplata implements TransakcjaInterface
{
    /**
     * Rachunek którego dotyczy transakcjia
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
     * @param RachunekInterface $rachunek Rachunek docelowy
     * @param int $kwota Wartość wpłaty
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

        $this->rachunek->setSaldo($this->rachunek->getSaldo() + $this->kwota);

        $this->status = Status::EXECUTED;
        $this->saldo = $this->rachunek->getSaldo();

        $this->rachunek->addHistoria($this);
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
        return sprintf('Wpłata [%s]: %.2d, saldo: %.2d', $this->status, $this->kwota, $this->saldo);
    }
}

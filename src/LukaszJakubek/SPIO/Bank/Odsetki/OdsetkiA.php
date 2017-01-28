<?php
/**
 * Definicja mechanizmu odsetkowego typu A
 */

namespace LukaszJakubek\SPIO\Bank\Odsetki;

use LukaszJakubek\SPIO\Bank\Rachunek\RachunekInterface;

/**
 * Mechanizm obliczania odsetek typu A
 *
 * Jedna stała wartość procentowa bez względu na saldo rachunku
 *
 * @author Łukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
class OdsetkiA implements OdsetkiInterface
{
    /**
     * Wartość odsetek w zapisie dziesiętnym
     *
     * @var float
     */
    private $oproc;

    /**
     * Tworzy mechanizm odsetkowy
     *
     * @param float $oprocentowanie
     */
    public function __construct($oprocentowanie)
    {
        $this->oproc = $oprocentowanie;
    }

    /**
     * Oblicza wartośc odsetek
     *
     * @param RachunekInterface $rachunek
     * @return int
     */
    public function oblicz(RachunekInterface $rachunek)
    {
        if ($rachunek->getSaldo() <= 0) {
            return 0;
        }

        return (int) ($this->oproc * $rachunek->getSaldo());
    }
}
